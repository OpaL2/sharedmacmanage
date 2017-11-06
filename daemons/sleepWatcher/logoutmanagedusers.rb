#!/usr/bin/env ruby
# encoding: utf-8

require_relative 'defaults'
require_relative 'log'
require_relative 'systools'

defaults = Defaults.new("/Library/Preferences/SharedMacManage.plist")
log = Log.new(defaults.read :LogFile)
usernames = defaults.readArray :ManagedUsers
log.write "INFO -- System entering forced sleep state, logging out managed users"


loggedUsers=SysTools.getLoggedUsers


usernames.each do |u|
  SysTools.logout u if loggedUsers.include? u
end