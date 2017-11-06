# encoding: utf-8

class Log
  def initialize file
    @log_file = file
  end
  
  def write message
    timestamp = `date`
    system("echo \"#{timestamp.strip} -- #{message}\" >> #{@log_file}")
  end
  
  def read
    `cat #{@log_file}`
  end
end