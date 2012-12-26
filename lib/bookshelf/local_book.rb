module Bookshelf
  # This represents a book stored in the local bookshelf path
  class LocalBook
    # The absolute path of the book
    attr_accessor :absolute_path

    if DRYRUN
      include FileUtils::DryRun
    elsif VERBOSE
      include FileUtils::Verbose
    else
      include FileUtils
    end

    # Determines if the file has been flagged (labelled red)
    def self.flagged
      @flagged ||= XAttr.in(Bookshelf::local_folder).map{ |s| new(s) }
    end

    # Make a new book with a given path
    def initialize path
      @absolute_path = File.expand_path(path)
    end

    # Determines the name of the book (the file name)
    def name
      File.basename(absolute_path)
    end

    # Determines the path of the file relative to the local folder
    def relative_path
      @relative_path ||= absolute_path.sub(/^#{Bookshelf::local_folder}\/?/,'')
    end
    
    # Unflags the book (removes a red label from it)
    def unflag!
      XAttr.unflag!(absolute_path)
    end

    # Copies the book to the remote directory
    def copy_to_remote!
      remote_path = File.join(Bookshelf::remote_folder, relative_path)
      mkdir_p File.dirname(remote_path)
      cp absolute_path, remote_path
    end
  end
end