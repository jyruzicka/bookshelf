module Bookshelf
  # This represents a book stored in the local bookshelf path
  class LocalBook
    attr_accessor :absolute_path

    if DRYRUN
      include FileUtils::DryRun
    elsif VERBOSE
      include FileUtils::Verbose
    else
      include FileUtils
    end

    def self.flagged
      @flagged ||= XAttr.in(Bookshelf::local_folder).map{ |s| new(s) }
    end

    def initialize path
      @absolute_path = File.expand_path(path)
    end

    def name
      File.basename(absolute_path)
    end

    def relative_path
      @relative_path ||= absolute_path.sub(/^#{Bookshelf::local_folder}\/?/,'')
    end
    
    def unflag!
      XAttr.unflag!(absolute_path)
    end

    def copy_to_remote!
      remote_path = File.join(Bookshelf::remote_folder, relative_path)
      mkdir_p File.dirname(remote_path)
      cp absolute_path, remote_path
    end
  end
end