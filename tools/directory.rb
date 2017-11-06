# encoding: utf-8

require_relative 'zipdirectory'
require 'date'

class Directory
  attr_accessor :remove_table, :dig_table, :keep_table, :recursive_keep_table

  def initialize(username , backup, &block)
    self.remove_table = []
    self.dig_table = []
    self.keep_table = []
    self.recursive_keep_table = []
    @user = username
    @home = "/Users/#{@user}"
    @backup_path = backup.strip().gsub(/\/$/, '')
    instance_eval(&block)
  end
  
  def expandHomeDirectory (path)
    tmp = path.gsub(/~/, @home)
    tmp = tmp.strip().gsub(/\/$/, '')
    tmp
  end
  
  def keep(path, *options)
    if options.include? :recursive
      self.recursive_keep_table << expandHomeDirectory(path)
    else
      self.keep_table << expandHomeDirectory(path)
    end
  end
  
  def remove(path, *options)
    if options.include? :subdirs_only
      self.remove_table += Dir[expandHomeDirectory(path) + "/*"]
    else
      self.remove_table << expandHomeDirectory(path)
    end
  end
  
  def _build
    #Digging all locations specified in dig table
    
    self.dig_table.each do |v|
      self.remove_table += Dir[v + "/*"]
    end
    self.dig_table = []
    self.remove_table = self.remove_table.uniq
    
    #Clearing remove table from recursive keep directories
    if !self.recursive_keep_table.empty?
      rec_keep_regexp = self.recursive_keep_table.map { |i| Regexp.new("^" + Regexp.escape(i))}
      to_remove = []
      for v in self.remove_table
        for r in rec_keep_regexp
          if !(r =~ v)
            to_remove << v
            end
          end
      end
      self.remove_table = to_remove
    end
    
    #testing if we need to dig more some paths in remove table
    remove_regexp = self.remove_table.map { |i| Regexp.new("^" + Regexp.escape(i))}
    for v in self.keep_table
      remove_regexp.each_with_index do |r, i|
        if (r =~ v)
          self.dig_table << self.remove_table[i]
        end
      end
    end
    self.dig_table = self.dig_table.uniq
    
    #removing locations to be digged from remove table
    self.remove_table = self.remove_table - self.dig_table
  
  end
  
  def build
    #building remove table:
    loop do
      _build
      break if self.dig_table.empty?
    end  
  end
  
  def clear
    self.remove_table.each do |v|
      system ("rm -r #{v}")
    end
  end
  
  def _backup
    #initializing name
    name = "backup_#{@user}_#{Date.today.prev_day.strftime("%Y%m%d")}"
    location = "#{@backup_path}/#{name}"
    #creating backup directory
    system("mkdir #{location}")
    
    #cloning remove locations for backup
    self.remove_table.each do |v|
      system("cp -r #{v} #{location}/.")
    end
    
    #Creating zip file from copied directories
    zipper = ZipDirectory.new(location, "#{location}.zip")
    zipper.write()
    
    #remove backup directory after zipping
    system("rm -r #{location}")
    
  end
    
  def backup
    _backup unless self.remove_table.empty?
  end
  
  def to_s
    output = "Directory clearing:\n\n"
    
    output << "Locations to keep:\n"
    self.keep_table.each do |l|
      output << "#{l.to_s}\n"
    end
    
    output << "\nLocations to keep recursively:\n"
    self.recursive_keep_table.each do |l|
      output << "#{l}\n"
    end
    
    output << "\nLocations to remove:\n"
    self.remove_table.each do |l|
      output << "#{l.to_s}\n"
    end
    
    output << "\nLocations in dig table:\n"
    self.dig_table.each do |l|
      output << "#{l}\n"
    end
    
    output
  end
  
  private :_build, :_backup
  
end