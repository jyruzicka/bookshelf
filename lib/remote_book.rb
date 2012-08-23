require 'yaml'

class Bookshelf::RemoteBook < Bookshelf::Book
  def self.equivalents
    @equvalents ||= YAML::load_file(equivalents_file)
  end
  
  def self.equivalents_file
    File.join(Bookshelf::remote_folder, '.bookshelf')
  end
  
  def self.save_equivalents
    File.open(equivalents_file,'w'){ |io| io.puts YAML::dump(@equivalents) }
  end

  def initialize path
    path = File.join(Bookshelf::remote_folder, path)
    super(path)
  end
  
  def pull
    unless local_equivalent.exists? && mtime < local_equivalent.mtime
      FileUtils::cp path, local_equivalent.path
    end
  end
  
  def local_equivalent
    Bookshelf::LocalBook.new(self.class.equivalents[name])
  end
  
  def point_to path
    self.class.equivalents[name] = path
    self.class.save_equivalents
  end
end