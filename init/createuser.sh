#!/bin/bash

#This script creates new user, it takes in whole name, username and password as command line args.
#It is only meant to be used for generating managed users in fi.olari.manage setup.
#expects that domain fi.olari.manage is created and script CreateEssentials.sh is executed before.

ARGS=3
E_BADARGS=85


LOG=$(defaults read /Library/Preferences/fi.olari.manage.plist LogFile)
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
	echo "Usage: `basename $0` username realname password"
	exit $E_BADARGS
fi

USERNAME=$1
REALNAME=$2
PASSWORD=$3

#Getting UserID
MAXID=$(dscl . -list /Users UniqueID | awk '{print $2}' | sort -n | tail -1)
USERID=$((MAXID+1))

GROUP="managed"

#Creating new user:
dscl . -create /Users/$USERNAME
dscl . -create /Users/$USERNAME UniqueID "$USERID"
dscl . -create /Users/$USERNAME UserShell /bin/bash
dscl . -create /Users/$USERNAME RealName "$REALNAME"
dscl . -create /Users/$USERNAME PrimaryGroupID 20
dscl . -create /Users/$USERNAME NFSHomeDirectory /Users/$USERNAME
dscl . -passwd /Users/$USERNAME $PASSWORD
dscl . -append /Groups/$GROUP GroupMembership $USERNAME

writeLog "INFO -- created new user $USERNAME"

#Adding user as managed user to preferences
defaults write /Library/Preferences/fi.olari.manage.plist ManagedUsers -array-add "$USERNAME"
writeLog "INFO -- added new user $USERNAME to managed users list in fi.olari.manage.plist"