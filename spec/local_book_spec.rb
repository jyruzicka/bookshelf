require './spec/spec_helper'

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