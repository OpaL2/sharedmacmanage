#!/bin/bash

#Script sets up institutional File Vault with given key and plist

ARGS=2
E_BADARGS=85
KEYCHAIN_PATH="/Library/Keychains/FileVaultMaster.keychain"

LOG=$(defaults read /Library/Preferences/SharedMacManage.plist LogFile)
writeLog() {
	timestamp=$(date)
	echo "$timestamp -- $1" >> $LOG
}

if [[ $EUID -ne 0 ]]; then
	writeLog "ERROR -- $0 was not runned as root!"
	echo "Please run $0 as root!" && exit 1
fi

if [ $# -ne $ARGS ]; then
	writeLog "ERROR -- $0 was supplied with $# arguments required ${ARGS}"
	echo "Usage: `basename $0` path_to_plist path_to_keychain"
	exit $E_BADARGS
fi


cp $2 $KEYCHAIN_PATH
chown root:wheel $KEYCHAIN_PATH
chmod 644 $KEYCHAIN_PATH

fdesetup enable -inputplist < $1 -keychain -norecoverykey
writeLog "INFO -- File Vault enabled"