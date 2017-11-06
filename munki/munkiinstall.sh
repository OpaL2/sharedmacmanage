#!/bin/bash

#Script wraps installer to use specific plist file, defined by constant INSTALL_CONFIG

INSTALL_CONFIG='/Volumes/SETUP/munki/munkiinstall_sample.plist'

if (($EUID != 0 )); then
  echo "SCRIPT MUST BE RUNNED AS ROOT"
else


echo 'Installing munki'
installer -file $INSTALL_CONFIG

echo 'Munki installed please Reboot machine'
fi