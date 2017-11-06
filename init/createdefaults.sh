#!/bin/bash

#Script create sharedmacmanage plist domain and writes some default settings to it

LOGFILE="/usr/local/sharedmacmanage/sharedmanage.log"
SHADOWHOME="/usr/local/sharedmacmanage/backup"

if [[ $EUID -ne 0 ]]; then 
  echo "Please run $0 as root!" && exit 1
fi

defaults write /Library/Preferences/SharedMacManage.plist LogFile -string "$LOGFILE"
defaults write /Library/Preferences/SharedMacManage.plist BackupPath -string "$SHADOWHOME"
defaults write /Library/Preferences/SharedMacManage.plist ManagedUsers -array 
defaults write /Library/Preferences/SharedMacManage.plist KeepBackup -int 30
defaults write /Library/Preferences/SharedMacManage.plist NetworkAdapter -string "en0"