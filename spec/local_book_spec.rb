require './spec/spec_helper'

=begin
module Bookshelf
  # This represents a book stored in the local bookshelf path
  class LocalBook

    def initialize path
      @absolute_path = path
    end

    def relative_path
      @relative_path = absolute_path.sub(/^#{Bookshelf::local_folder}/,'')
    end
    
    def saturate!
      xattr = XAttr.from_file(path)
      xattr.saturate!
      xattr.save path
    end
    
    def unflag!
      XAttr.unflag!(absolute_path)
    end

    def copy_to_remote
      remote_path = File.join(Bookshelf::remote_folder, relative_path)
      FileUtils::cp absolute_path, remote_path
    end
  end
end
=end
include Bookshelf

describe LocalBook do
  before :all do
    set_test_location
  end

  before :each do
    populate_working
  end

  describe "::flagged" do
    it "should detect all flagged classes" do
      LocalBook::flagged.size.should == 1
      LocalBook::flagged[0].relative_path.should == 'sample'
    end
  end

  describe "#relative_path" do
    it "should only have the relative path in it" do
      LocalBook.new(spec_data('local/sample')).relative_path.should == 'sample'
    end
  end

  describe "#copy_to_remote!" do
    it "should copy the file to the remote directory" do
      File.should_not exist(spec_data('remote/sample'))
      lb = LocalBook.new(spec_data('local/sample'))
      lb.copy_to_remote!
      File.should exist(spec_data('remote/sample'))
    end
  end


end