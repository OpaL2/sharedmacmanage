# encoding: utf-8

require_relative 'directory'
require_relative 'defaults'
require_relative 'log'
require_relative 'systools'
require 'date'

defaults = Defaults.new('/Library/Preferences/SharedMacManage.plist')
log = Log.new(defaults.read :LogFile)
network_adapter = defaults.read :NetworkAdapter
managedUsers = defaults.readArray :ManagedUsers

def removeOldBackups
  path = defaults.read(:BackupPath).strip().gsub(/\/$/, '')
  files = Dir[ path + '/*']
  days = defaults.read :KeepBackup
  lastToKeep = Date.today - (days.to_i + 1)
  files.each do |f|
    if /^backup_\S*_\d{8}\.zip$/ =~ File.basename(f)
      s = File.basename(f).gsub(/^backup_\S*_/, '')
      d = Date.strptime(s, '%Y%m%d')
      if (d < lastToKeep)
        system("rm #{f}")
      end
    end
  end

end

def cleanAndBackup user
  d = Directory.new(user, defaults.read(:BackupPath)) do
    remove "~", :subdirsOnly
    remove "~/.Trash", :subdirsOnly
    keep "~/Desktop"
    keep "~/Documents"
    keep "~/Downloads"
    keep "~/Library", :recursive
    keep "~/Public"
    keep "~/Public/Drop Box"
    keep "~/Pictures"
    keep "~/Movies"
    keep "~/Music"
    
    build
    backup
    clear
  end
end

log.write "INFO -- Started nightly updates"

SysTools.getloggedUsers.each do |u|
  SysTools.logout u
end

managedUsers.each do |u|
  cleanAndBackup u
end
log.write "INFO -- Cleared managed users home directories"

removeOldBackups
log.write "INFO -- Removed old backups"

#Enabling wifi adapter
system("ifconfig","#{network_adapter}","up")

#running munki updates
system("/usr/local/munki/supervisor","--delayrandom","3600","--timeout","14406","--","/usr/local/munki/managedsoftwareupdate","--auto")
log.write "INFO -- Software updated"

exit 0