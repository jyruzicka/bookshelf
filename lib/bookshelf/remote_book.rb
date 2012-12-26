module Bookshelf
  # This class represents books stored at our "remote" location.
  class RemoteBook
    # The absolute filepath of the book file
    attr_accessor :absolute_path

    if DRYRUN
      include FileUtils::DryRun
    elsif VERBOSE
      include FileUtils::Verbose
    else
      include FileUtils
    end

    # Returns all remote book files.
    def self.all
      glob = File.join(Bookshelf::remote_folder,'**','*')
      Dir[glob].select{ |f| !File.directory?(f)}.map{ |f| new(f) }
    end

    # Creates a new remote book file given a path
    def initialize path
      @absolute_path = File.expand_path(path)
    end

    # The name (filename) of the book file.
    def name
      File.basename(absolute_path)
    end

    # The path of the book relative to the remote folder
    def relative_path
      @relative_path ||= absolute_path.sub(/^#{Bookshelf::remote_folder}\/?/,'')
    end

    # Synchronise the book with its local equivalent, keeping the latest copy if they're different.
    def sync!
      local_book = File.join(Bookshelf::local_folder, relative_path)

      if File.exists?(local_book) && !FileUtils.cmp(absolute_path, local_book)
        if File.mtime(absolute_path) > File.mtime(local_book)
          cp absolute_path, local_book
          return :pull
        else
          cp local_book, absolute_path
          return :push
        end
      else
        return nil
      end
    end
  end
end