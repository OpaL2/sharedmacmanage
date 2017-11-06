# encoding: utf-8

class Defaults
  def initialize domain
    @domain = domain
  end

  def read field
    `defaults read #{@domain} #{field.to_s}`
  end
  
  def readArray field
    arr = self.read(field).split("\n")
    arr.delete("(")
    arr.delete(")")
    arr2 = []
    arr.each do |line|
      line = line.gsub(/,/,"").strip()
      arr2 << line
    end
    arr2
  end
  
  def write field, value
    system("defaults write #{@domain} #{field.to_s} \'#{value}\'")
  end
  
  def writeInt field, value
    system("defaults write #{@domain} #{field.to_s} -int #{value}")
  end
  
  def writeString field, value
    self.write field, value
  end
  
  def writeBool field, value
    if value
      system("defaults write #{@domain} #{field.to_s} -bool TRUE")
    else
      system("defaults write #{@domain} #{field.to_s} -bool FALSE")
    end
  end
  
  def writeArray field, *values
    str = "defaults write #{@domain} #{field.to_s} -array "
    values.each do |value|
      str += value
      str += " "
    end
    system(str)
  end
  
  def appendArray field, *values
    str = "defaults write #{@domain} #{field.to_s} -array-add "
    values.each do |value|
      str += value
      str += " "
    end
    system(str)
  end
end