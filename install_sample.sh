#!/bin/bash


#configurating setup script paths
INSTALL_FILE_PATH="/Volumes/SETUP/init/"
MUNKI_FILE_PATH="/Volumes/SETUP/munki/"
INSTALL_DATA_PATH="/Volumes/SETUP/init/"
MANAGEMENT_FILE_PATH="/Volumes/SETUP/manage/"

#Setting up os
source "${INSTALL_FILE_PATH}createdefaults.sh"
source "${INSTALL_FILE_PATH}createessentials.sh"

#Installing management software
source "${MANAGEMENT_FILE_PATH}manageinstall.sh"

#Creating managed users
source "${INSTALL_FILE_PATH}createuser.sh" 'oppilas' 'Oppilas' 'oppilas' #Username, Real Name, password, see CreateUser.sh

#Installing munki
source "${MUNKI_FILE_PATH}munkiinstall.sh"
ruby ${MUNKI_FILE_PATH}munkiconfig.rb

#Setting up file vault, power settings and firewall

ruby ${INSTALL_FILE_PATH}setupwakeup.rb
ruby ${INSTALL_FILE_PATH}setupfirewall.rb
#source "${INSTALL_FILE_PATH}setupinstitutionalfilevault.sh" "${INSTALL_DATA_PATH}filevault_sample.plist" "${INSTALL_DATA_PATH}FileVaultMaster.keychain"


#Rebooting system
echo 'Installation completed, rebooting...'
reboot

exit 0