require './spec/spec_helper'
include Bookshelf

describe LocalBook do
  def local name
    LocalBook.new(spec_data name)
  end
  
  after :each do 
    duplicate = spec_data('sample_dup')
    FileUtils::rm duplicate if File.exists?(duplicate)
  end
  
  describe "#coloured" do
    it "should pick up coloured data files" do
      Bookshelf::local_folder = spec_data
      coloured = LocalBook::coloured
      coloured.size.should == 1
      coloured[0].name.should == 'sample'
    end
  end
  
  describe "#coloured?" do
    it "should tell us if a data file is coloured" do
      local('sample').should be_coloured
      local('uncoloured').should_not be_coloured
    end
  end
  
  describe "#desaturate!" do
    it "should make a coloured file uncoloured" do
      FileUtils::cp spec_data('sample'), spec_data('sample_dup')
      duplicate = local('sample_dup')
      duplicate.saturate!
      duplicate.should be_coloured
      duplicate.desaturate!
      duplicate.should_not be_coloured   
    end
  end
end