require 'fileutils'

module Bookshelf
  class Book
    attr_accessor :path

    def initialize path
      @path = File.expand_path(path)
    end

    def mtime
      @mtime ||= (exists? ? File.mtime(path) : nil)
    end

    def exists?
      File.exists?(path)
    end

    def name
      File.basename(path)
    end
    
    def === other_book
      FileUtils.cmp(path, other_book.path)
    end
  end
end