#!/bin/bash

#Initializing script parameters, change these as nessecary
INSTALL_CONFIG='/Volumes/SETUP/manage/manageInstall_sample.plist'

if (($EUID != 0 )); then
	echo "SCRIPT MUST BE RUNNED AS ROOT"
	exit false
else

installer -file $INSTALL_CONFIG

echo 'Management software installed please Reboot machine'
fi