# The bookshelf module is our namespace
module Bookshelf
  class << self
    # Where we store out stuff locally
    attr_accessor :local_folder
    
    # Where we're deploying to
    attr_accessor :remote_folder
  end
end
# Defaults
Bookshelf::local_folder = File.join(ENV['HOME'], 'Books')
Bookshelf::remote_folder = File.join(ENV['HOME'], 'Dropbox', 'Books')

lib_root = File.join(File.dirname(File.realpath(__FILE__)), 'bookshelf')
Dir["#{lib_root}/*.rb"].each{ |f| require f }