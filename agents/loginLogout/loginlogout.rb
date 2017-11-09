
require_relative 'directory'
require_relative 'defaults'
require_relative 'log'

DEFAULTS = Defaults.new("/Library/Preferences/SharedMacManage.plist")
LOG = Log.new(DEFAULTS.read :LogFile)

def onLogin
  LOG.write "INFO -- user #{ENV['USER']} logged in"
end

def onLogout
  LOG.write "INFO -- user #{ENV['USER']} logged out"
  exit 0
end


Signal.trap("INT") {onLogout}
Signal.trap("HUP") {onLogout}
Signal.trap("TERM") {onLogout}

onLogin

loop do
  sleep 12
end
