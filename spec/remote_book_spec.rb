require './spec/spec_helper'

include Bookshelf

describe RemoteBook do

  before :all do
    set_test_location
  end

  before :each do
    populate_working
  end

  def make_remote filename, text=''
    full_file = File.join(Bookshelf::remote_folder, filename)
    poopulate full_file, text
  end

  def make_local filename, text=''
    full_file = File.join(Bookshelf::local_folder, filename)
    poopulate full_file, text
  end

  def poopulate file, text
    File.open(file,'w'){ |io| io << text }
  end

  describe "#all" do
    it "should grab all the remote books" do
      RemoteBook.all.size.should == 1
    end
  end

  describe "#relative_path" do
    it "should give the correct path" do
      RemoteBook.new(spec_data('remote/remote')).relative_path.should == 'remote'
    end
  end

  describe "#sync!" do
    it "should sync remote books back to local books if remote is newer" do
      make_local('syncfile', 'local')
      sleep 2
      make_remote('syncfile', 'remote') #made after local
      RemoteBook.new(spec_data 'remote/syncfile').sync!
      File.read(spec_data 'local/syncfile').should == 'remote'
    end

    it "should sync local books on to remote books if local is newer" do
      make_remote('syncfile', 'remote')
      sleep 2
      make_local('syncfile', 'local') #made after remote
      RemoteBook.new(spec_data 'remote/syncfile').sync!
      File.read(spec_data 'remote/syncfile').should == 'local'
    end
  end
end