#!/usr/bin/env ruby
# encoding: utf-8

#script is working, but triggers some errors

require '/usr/local/manage/lib/defaults'

d = Defaults.new "/Library/Preferences/com.apple.alf"
#unloading firewall service
`launchctl unload -F /System/Library/LaunchAgents/com.apple.alf.useragent.plist /System/Library/LaunchDaemons/com.apple.alf.agent.plist`

#enabling firewall
d.writeInt :globalstate, 1

#enabling stealth
d.writeInt :stealthenabled, 1

#enabling signed content and system apps
d.writeInt :allowdownloadsignedenabled, 1
d.writeInt :allowsignedenabled, 1

#loading firewall 
`launchctl load -wF /System/Library/LaunchAgents/com.apple.alf.useragent.plist /System/Library/LaunchDaemons/com.apple.alf.agent.plist`