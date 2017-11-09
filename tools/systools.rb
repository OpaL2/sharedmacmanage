# encoding: utf-8

module SysTools
  
  def self.root?
    ENV['USER'] == 'root'
  end
  
  def self.runIfRoot &block
    yield block if root?
  end
  
  def self.runIfNotRoot &block
    yield block unless root?
  end
  
  def self.getLoggedUsers
    `who | awk '{split($0, arr, " "); print arr[1]}'`.split("\n").uniq
  end
  
  def self.logout username
    system("launchctl bootout user/$(id -u #{username} )") == 0
  end
  
end