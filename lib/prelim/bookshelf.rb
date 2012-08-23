# The bookshelf module is our namespace
# Today I'm feeling whimsical. Expect silly names.
module Bookshelf
  class << self
    # Where we store out stuff locally
    attr_accessor :local_folder
    
    # Where we're deploying to
    attr_accessor :remote_folder
  end
  
  # Detect coloured books and associate them appropriately
  def self.detect
    # For each coloured book...
    LocalBook.coloured.each do |lf|
      lf.push!      # Push it to device. Who cares about timestamps?
      Map.create lf
      lf.desaturate # Un-colour the original file
    end
  end
  
  # Pull all changes from remote_folder
  def self.pull
    RemoteBook.all.each do |rf|
      rf.pull # Without the exclamation point, will check to see if it's newer than source.
    end
  end
  
  # Push all changes to remote_folder
  def self.push
    RemoteBook.all.each do |rf|
      rf.local_file.push
    end
  end
  
  # Clean maps
  def self.clean
    Map.clean
  end
end

Bookshelf::local_folder = File.join(ENV['HOME'], 'Books')
Bookshelf::remote_folder = File.join(ENV['HOME'], 'Dropbox', 'Books')