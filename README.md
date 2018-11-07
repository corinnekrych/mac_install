# Laptop setup

Welcome to the mac_insatll script!
The awsome script that turns your mac into a killer development machine.

My dev profile is: 
- mobile dev (Xcode, CocoaPods, Cordova)
- JavaScript dev (nvm, nodejs)
- golang (gvm)

## Customize script

### Set-up for GPG and SSH key

In the same folder where you got you script, your should have:
* `pub.gpg` and `sec.gpg` files
* ssh.tar which contain your .ssh content

In `mac_install.sh` script customize GPG by adding your GPG key.

To generate those files, follow the step below:

#### Export you GPG
If you have a GPG key you want to import in your new macOS configuration, export you public and private key:

```
gpg --output pub.gpg --armor --export YOUR_KEY
gpg --output sec.gpg --armor --export-secret-key YOUR_KEY
```

#### Tar your .ssh 
To keep the correct rights:
```
tar cvpf ssh.tar ./ssh
```
## Github repos

If you want to clone your working repos in `$HOME/workspace` folder:
* add a file `github.txt` which contains a git repo per line. Similar to [feedhenry_github.txt](feedhenry_github.txt)
* in  `./mac_install.sh` call the function to clone them all with the `prefix` of `prefix_github.com`:
```
clone_repo "feedhenry"
```

## Run the script
```
. ./mac_install.sh
```
