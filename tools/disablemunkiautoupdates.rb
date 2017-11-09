#!/usr/bin/env ruby
# encoding: utf-8

exit system("launchctl", "unload", "-wF", "/Library/LaunchDaemons/com.googlecode.munki.managedsoftwareupdate-check.plist")