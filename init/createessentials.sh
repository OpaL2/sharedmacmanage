#!/bin/bash

#Scritp creates some essentials for initializing machine to fi.olari.manage system.
#Expects that defaults domain is already written.

LOG=$(defaults read /Library/Preferences/SharedMacManage.plist LogFile)
BACKUP=$(defaults read /Library/Preferences/SharedMacManage.plist BackupPath)
writeLog() {
  timestamp=$(date)
  echo "$timestamp -- $1" >> $LOG
}

if [[ $EUID -ne 0 ]]; then 
  echo "Please run $0 as root!" && exit 1
fi


touch $LOG
chmod 633 $LOG
writeLog "INFO -- Log file created"

dseditgroup -o create -r "SharedMacManage" managed
writeLog "INFO -- created user group managed"

BASE="/usr/local/sharedmacmanage"
mkdir $BASE $BASE/lib
mkdir -p $BACKUP

writeLog "INFO -- created directory structure"
