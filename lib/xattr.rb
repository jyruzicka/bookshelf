module Bookshelf
  class XAttr
    attr_accessor :entries
    
    REGEXP = Regexp.new(['([0-9A-F]{2})']*32*'\s','m')
    
    def initialize str=nil
      @entries = ['00'] * 32
      if m = REGEXP.match(str)
        @entries = ['00'] * 32
        1.upto(32).each do |i|
          @entries[i-1] = m[i]
        end
      end
    end
    
    def self.from_file f
      new `xattr -p com.apple.FinderInfo '#{f}' 2>&1`
    end
    
    def [] k
      @entries[k]
    end
    
    def []= k,v
      @entries[k] = v
    end
    
    def coloured?
      @entries[9] == '0C'
    end
    
    def saturate!
      @entries[9] = '0C'
    end
    
    def desaturate!
      @entries[9] = '00'
    end
    
    def save file
      `xattr -wx com.apple.FinderInfo '#{to_s}' '#{file}'`
    end
    
    def to_s
      @entries[0,16] * ' ' + "\n" + @entries[16,16] * ' '
    end
  end
end