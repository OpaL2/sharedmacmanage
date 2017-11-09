# Shared Mac Manage

## Installation

### Create own versions of following files:
* init/filevault_sample.plist
* manage/manageInstall_sample.plist
* munki/munkiinstall_sample.plist

### After creating these plists refactor following scritps for your needs:
* manage/manageinstall.sh
* munki/munkiinstall.sh
* munki/munkiconfig.rb

### Make installation script
You can use script install_sample.sh as source script. Your own install script should run least following files in presented order:
1. init/createdefaults.sh
2. init/createessentials.sh
3. manage/manageinstall.sh (your own refactored version)
4. munki/munkiinstall.sh (your own refactored version)
5. munki/munkiconfig.rb (your own refactored version)

You can add following parts to your script as needed:
* init/createuser.sh -- For creating managed users
* init/setupwakeup.rb -- Set pmsetting for wakeup every night at 02:00
* init/setupfirewall.rb -- Enables alf firewall, currently running causes some errors but works correctly
* init/setupinstitutionalfilevalut.sh -- Setting file valut for institutional use 

Your installation script should reboot machine after running all parts of installation.

### Installing to client machines
Copy source files and other resources as plists and pkg files to client machine. You can create also a USB memory stick for installing. On client machine run your install script and see magic happening. 

### Notes
You need to install [munki version 3](https://github.com/munki/munki) in order to this software work. Installing munki is wrapped in install_sample.sh script by using scripts in munki folder.