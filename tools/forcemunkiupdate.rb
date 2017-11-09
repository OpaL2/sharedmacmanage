#!/usr/bin/env ruby
# encoding: utf-8

#Runs forced munki update

require_relative "systools"

def main()
  system("caffeinate", "-i", "-d", "/usr/local/munki/managedsoftwareupdate")
  system("caffeinate", "-i", "-d", "/usr/local/munki/managedsoftwareupdate", "--installonly")
  system("reboot")
end


SysTools.runIfNotRoot {puts "MUST BE RUNNED AS ROOT!!!" }

SysTools.runIfRoot { main() }

exit
