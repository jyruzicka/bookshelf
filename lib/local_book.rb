module Bookshelf
  class LocalBook < Book
    def self.coloured
      glob = File.join(Bookshelf::local_folder, '**', '*')
      coloured_files = Dir[glob].select do |f|
        XAttr.from_file(f).coloured?
      end
      coloured_files.map{ |p| new(p) }
    end
    
    def coloured?
      XAttr.from_file(path).coloured?
    end
    
    def saturate!
      xattr = XAttr.from_file(path)
      xattr.saturate!
      xattr.save path
    end
    
    def desaturate!
      xattr = XAttr.from_file(path)
      xattr.desaturate!
      xattr.save path
    end
    
    def push
      push! unless self === remote or
        self.mdate > remote.mdate
    end
    
    def push!
      FileUtils::cp path, remote.path
    end
    
    def remote
      File.join(Bookshelf::remote_folder, name)
    end    
  end
end