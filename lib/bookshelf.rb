require 'fileutils'

# The bookshelf module is our namespace
module Bookshelf
  class << self
    # Where we store out stuff locally
    attr_accessor :local_folder

    def local_folder= new_folder
      @local_folder = File.expand_path(new_folder)
    end
    
    # Where we're deploying to
    attr_accessor :remote_folder

    def remote_folder= new_folder
      @remote_folder = File.expand_path(new_folder)
    end

    # Allowed file types
    attr_accessor :file_types

    # Convert file types to glob
    def file_glob
      if file_types.nil?
        '*'
      else
        "*{#{file_types.join(',')}}"
      end
    end
  end
end
# Defaults
Bookshelf::local_folder = File.join(ENV['HOME'], 'Books')
Bookshelf::remote_folder = File.join(ENV['HOME'], 'Dropbox', 'Books')
Bookshelf::file_types = %w(pdf epub mobi txt)

def vputs str
  puts(str) if VERBOSE
end

lib_root = File.join(File.dirname(File.realpath(__FILE__)), 'bookshelf')
Dir["#{lib_root}/*.rb"].each{ |f| require f }