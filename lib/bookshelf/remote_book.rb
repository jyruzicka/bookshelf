module Bookshelf
  class RemoteBook
    attr_accessor :absolute_path

    def self.all
      glob = File.join(Bookshelf::remote_folder,'**','*')
      Dir[glob].map{ |p| new(p) }
    end

    def initialize path
      @absolute_path = path
    end

    def relative_path
      @relative_path ||= absolute_path.sub(/^#{Bookshelf::remote_folder}\/?/,'')
    end

    def sync!
      local_book = File.join(Bookshelf::local_folder, relative_path)

      if File.exists?(local_book) && !FileUtils.cmp(absolute_path, local_book)
        if File.mtime(absolute_path) > File.mtime(local_book)
          FileUtils::cp absolute_path, local_book
        else
          FileUtils::cp local_book, absolute_path
        end
      end
    end
  end
end