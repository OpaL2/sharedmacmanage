#!/usr/bin/env ruby
# encoding: utf-8

#Scritp writes munki setup, see tools.defaults for more information about default plist acces

require '/usr/local/sharedmacmanage/lib/defaults'
require '/usr/local/sharedmacmanage/lib/systools'

REPO='olari_munki_client'
SERVERURL='http://munki.olarinlukio.fi/munki_repo'

SysTools.runIfNotRoot do
  puts 'Munki config must be runned as root'
  exit false
end

d = Defaults.new("/Library/Preferences/ManagedInstalls.plist")

d.write :SoftwareRepoURL, SERVERURL
d.write :ClientIdentifier, REPO
d.writeBool :InstallAppleSoftwareUpdates, true
d.writeBool :UnattendedAppleUpdates, true
d.writeBool :SuppressUserNotification, true
d.writeBool :SuppressAutoInstall, false
d.writeBool :InstallRequiresLogout, true


exit true