module Bookshelf
  # This represents a book stored in the local bookshelf path
  class LocalBook
    attr_accessor :absolute_path

    def self.flagged
      glob = File.join(Bookshelf::local_folder, '**', '*')
      Dir[glob].select{ |f| XAttr.flagged?(f) }.map{ |p| new(p) }
    end

    def initialize path
      @absolute_path = path
    end

    def relative_path
      @relative_path ||= absolute_path.sub(/^#{Bookshelf::local_folder}\/?/,'')
    end
    
    def unflag!
      XAttr.unflag!(absolute_path)
    end

    def copy_to_remote!
      remote_path = File.join(Bookshelf::remote_folder, relative_path)
      FileUtils::cp absolute_path, remote_path
    end
  end
end