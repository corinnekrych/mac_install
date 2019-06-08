#!/bin/bash

# Welcome to the mac_insatll script!
# The awsome script that turns your mac into a killer 
# development machine.
echo "==> Welcome to mac_install."
# Homebrew install
if test ! $(which brew)
then
	echo "==> Install Homebrew"
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Install cask for brew
echo "==> Install Cask"
brew tap caskroom/cask
brew tap caskroom/versions

# Update brew
echo "==> Update Homebrew"
brew update
#brew upgrade brew-cask

# Install mas (Mac App Store)
echo "==> Install mas for Mac App Store."
brew_install mas


# Function to install from App Store with mas (source : https://github.com/argon/mas/issues/41#issuecomment-245846651)
function install () {
	# Check if the App is already installed
	mas list | grep -i "$1" > /dev/null

	if [ "$?" == 0 ]; then
		echo "==>==> $1 already installed!"
	else
		echo "==>==> Installing $1..."
		mas search "$1" | { read app_ident app_name ; mas install $app_ident ; }
	fi
}

function app_is_installed() {
  local app_name
  app_name=$(echo "$1" | cut -d'-' -f1)
  find /Applications -iname "$app_name*" -maxdepth 1 | egrep '.*' > /dev/null
}

function app_is_installed_cask() {
  local app_name
  app_name=$(echo "$1" | cut -d'-' -f1)
  find /usr/local/Caskroom -iname "$app_name*" -maxdepth 1 | egrep '.*' > /dev/null
}

function app_is_installed_homebrew() {
  local app_name
  app_name=$(echo "$1" | cut -d'-' -f1)
  find /usr/local/Cellar -iname "$app_name*" -maxdepth 1 | egrep '.*' > /dev/null
}

function append_to_file() {
  local file="$1"
  local text="$2"

  if ! grep -qs "^$text$" "$file"; then
    printf "\n%s\n" "$text" >> "$file"
  fi
}

# Install with brew cask
function cask_install() {
	if ! app_is_installed_cask $1; then
		if ! app_is_installed $1; then
			echo "==> Install $1"
			brew cask install $1
			if [[ $2 ]]; then 
				echo "==>==> Dock $2"
				defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/$2.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
			fi
		fi
	fi
}
# Install with brew
function brew_install() {
	if ! app_is_installed_homebrew $1; then
		if ! app_is_installed $1; then
			echo "==> Install $1"
			brew install $1
			if [[ $2 ]]; then 
				echo "==>==> Dock $2"
				defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>/Applications/$2.app</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
			fi
		fi
	fi
}
cask_install java
brew_install p7zip
brew_install wget 
brew_install ack 
brew_install maven
brew_install gpg 
brew_install zsh zsh-completions 
brew_install git
brew_install go
brew_install glide
brew_install mercurial
brew_install bazaar
brew_install glide
# brew_install kedge

brew_install gnu-getopt
echo 'export PATH="/usr/local/opt/gnu-getopt/bin:$PATH"' >> ~/.zshrc

brew_install postgres
brew_install graphviz
brew_install kubectl

cask_install goland "GoLand"
cask_install iterm2 
cask_install sublime-text 
cask_install atom atom
cask_install firefox firefox
cask_install dropbox 
cask_install colloquy colloquy
cask_install google-chrome "Google Chrome"
alias chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"
cask_install google-chrome-canary "Google Chrome Canary"
alias chrome-canary="/Applications/Google\ Chrome\ Canary.app/Contents/MacOS/Google\ Chrome\ Canary"
cask_install diffmerge
cask_install mattermost mattermost
cask_install intellij-idea "intelliJ IDEA"
cask_install webstorm webstorm
cask_install slack slack
cask_install virtualbox virtualbox
cask_install visual-studio-code "Visual Studio Code"
cask_install docker


if [ ! -d "$HOME/workspace/go" ]; then
	echo "==> Setup GO"
	mkdir -p $HOME/workspace/go
	append_to_file "$HOME/.zshrc" 'export GOPATH=$HOME/workspace/go'
fi

# if ! app_is_installed_cask 'blue-jeans-launcher'; then
# 	echo "==> Setup for BlueJeans app"
# 	brew cask install blue-jeans-launcher
# 	open /usr/local/Caskroom/blue-jeans-launcher/1.6.8/Blue\ Jeans\ Launcher.app
# fi

# Install oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
	echo "==> Install oh-my-zsh"
	chsh -s $(which zsh)
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

# Install rvm
if [ ! -d "$HOME/.rvm" ]; then
	echo "==> Install rvm"
	curl -L https://get.rvm.io | bash -s stable
	. ~/.bash_profile
	rvm install 2.3.0 --disable-binary
fi

# Install GVM for golang environment
if [ ! -d "$HOME/.gvm" ]; then
	echo "==> Install gvm"
	zsh < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
	source "$HOME/.zshrc"
	gvm install go1.10.5
	gvm use go1.10.5 --default
fi

# Install JavaScript environment
if [ ! -d "$HOME/.nvm" ]; then
	echo "==> Install nvm"
	curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh | bash
	append_to_file "$HOME/.zshrc" 'export NVM_DIR="$HOME/.nvm"'
	append_to_file "$HOME/.zshrc" '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm'
	source "$HOME/.zshrc"
	nvm install v10.15.1
	nvm install v8.3.0
	nvm alias default v10.15.1
fi
if ! app_is_installed_homebrew yarn; then
	echo "==> Install yarn"
	# https://yarnpkg.com/en/docs/install add --without-node when nvm is insatlled
	brew install yarn --without-node
fi

# Install npm-run.pugin.zsh /Users/corinne/.npm-run.plugin.zsh
if [ ! -d "$HOME/.npm-run.plugin.zsh" ]; then
	echo "==> Install npm-run"
	npm install -g npm-run.plugin.zsh
fi

if [ ! -d "/usr/local/oc" ]; then
	echo "==> Install Openshift oc"
	brew install socat #dependency for oc
	wget https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-mac.zip
	sudo unzip openshift-origin-client-tools-v3.11.0-0cbc58b-mac.zip -d /usr/local/oc
	ln -s /usr/local/oc/oc /usr/local/bin/oc
fi

# Install MiniKube
if [ ! -d "/usr/local/bin/minikube" ]; then
	echo "==> Install Minikube"
	brew update
  brew install --HEAD xhyve
	brew install docker-machine-driver-xhyve
	brew cask install minikube
fi

# Install Minishift
if [ ! -d "/usr/local/bin/minishift" ]; then
	brew update
  brew install --HEAD xhyve
	brew install docker-machine-driver-xhyve
	brew cask install minishift
fi

# Install with mas
if ! app_is_installed 'Xcode'; then
	echo "= Enter your AppleID:" 
	read APPLE_ID
	echo "==> Enter your Apple ID’s password: $APPLE_ID"
	read -s PASSWORD
	mas signin $APPLE_ID "$PASSWORD"
	echo "==> Install Xcode"
	install "Xcode"
	sudo xcodebuild -license accept
	echo "==> mMke xcodebuild available"
	sudo xcode-select -switch /Applications/Xcode.app 
fi

# Install with gem
if [ ! -d "$HOME/.cocoapods" ]; then
	echo "==> Install CocoaPods"
	sudo gem install cocoapods
fi

# Set-up GPG, SSH Keys
if [ -f "./gpg_pub.gpg" ]; then
	if [ ! -d "$HOME/.gnupg" ]; then
		echo "==> Set-up GPG key"
		gpg --import ./gpg_pub.gpg
		gpg --allow-secret-key-import --import ./gpg_sec.gpg 
		# TODO replace FD8D377A with your GPG key
		echo "$( \
	   		gpg --list-keys --fingerprint \
	   		| grep FD8D377A -A 1 | tail -1 \
	   		| tr -d '[:space:]' | awk 'BEGIN { FS = "=" } ; { print $2 }' \
	 	):6:" | gpg --import-ownertrust;
	fi
fi

# Set-up SSH
if [ -f "./ssh.tar" ]; then
	if [ ! -d "$HOME/.ssh" ]; then
		echo "==> Set-up .ssh"
		tar xvpf ./ssh.tar --directory ~
		echo "==> Set-up git"
 		git config --global user.name "Corinne Krych"
 		git config --global user.email corinnekrych@gmail.com
	 fi
fi

# Set-up chat, irc
if [ -f "./colloquy.backup" ]; then
	echo "==> Import IRC chat settings"
	defaults import info.colloquy colloquy.backup
fi

if [ ! -f Tunnelblick_3.7.9a_build_5321.dmg ]; then
	wget https://tunnelblick.net/release/Tunnelblick_3.7.9a_build_5321.dmg
	echo "tunnelblick required manual install..."
	# hdiutil attach Tunnelblick_3.7.4b_build_4921.dmg
	# cp "/Volumes/Tunnelblick/Tunnelblick.app" /Applications
	# hdiutil detach "/Volumes/Tunnelblick"
	popd
fi

# Set-up workspace with relevant git repos
function clone_repo () {    
    repos=() # Create array
    while IFS= read -r line # Read a line
    do
        repos+=("$line") # Append line to the array
    done < "$1_github.txt"

	current_dir=$(pwd)
	echo "==> Create workspace for $1"
	mkdir -p ~/workspace/$1
	cd ~/workspace/$1
	for repo in ${repos[@]}
	do
		last_string=$(echo $repo| cut -d'/' -f 2)
		repo_directory=$(echo $last_string| cut -d'.' -f 1)	
		if [ $1 == "go" ]; then
			tmp_string=$(echo $repo| cut -d':' -f 2)
		    github_org=$(echo $tmp_string| cut -d'/' -f 1)	
			if [ ! -d "src/github.com/$github_org/$repo_directory" ]; then
				echo "==> Clone GO repo: $repo with github $github_org and repo directory $repo_directory"
				git clone $repo ~/workspace/go/src/github.com/$github_org/$repo_directory
			else
				echo "==> GO Directory $repo_directory already created with github $github_org and repo directory $repo_directory."
			fi
		else
			if [ ! -d "$repo_directory" ]; then
				echo "==> Clone $repo"
				git clone $repo
			else
		    	echo "==> Directory $repo_directory already created."
			fi
		fi
	done
	cd  $current_dir
}
# echo "==> Clone devtools platform repos"
# clone_repo "devtools"
echo "==> Clone corinnekrych repos"
clone_repo "corinne"
echo "==> Clone go repos"
clone_repo "go"

# Finder 
echo "==> Set-up Finder"
chflags nohidden ~/Library
defaults write com.apple.finder AppleShowAllFiles TRUE
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder FXPreferredViewStyle -string “Nlsv”
defaults write com.apple.finder ShowPathbar -bool true
sudo defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# TODO settings -> keyboard -> shortcuts -> services -> files and folders New Terminal at folder / New terminal tab at folder => on

# Print home folder
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

# Search in current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Do not create .DS_STORE
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Cleaning
killall Dock
killall Finder
brew cleanup
rm -rf /Library/Caches/Homebrew/
