# encoding: utf-8

module SysTools
  
  def SysTools.root?
    ENV['USER'] == 'root'
  end
  
  def SysTools.runIfRoot &block
    yield block if root?
  end
  
  def SysTools.runIfNotRoot &block
    yield block unless root?
  end
  
  def SysTools.getLoggedUsers
    `who | awk '{split($0, arr, " "); print arr[1]}'`.split("\n").uniq
  end
  
  def SysTools.logout username
    system("launchctl bootout user/$(id -u #{username} )") == 0
  end
  
end