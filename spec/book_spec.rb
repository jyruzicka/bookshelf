require './spec/spec_helper'
include Bookshelf

describe Book do
  def book str
    Book.new(spec_data(str))
  end
  
  after :each do
    duplicate = spec_data('sample_dup')
    FileUtils::rm duplicate if File.exists?(duplicate)
  end
  
  describe "#mtime" do
    it "should give a modified time for existant files" do
      book('sample').mtime.class.should == Time
    end
    
    it "should give nil for a nonexistant file" do
      book('foo').mtime.should be_nil
    end
  end
  
  describe "#===" do
    it "should consider copies equivalent" do
      FileUtils::cp spec_data('sample'), spec_data('sample_dup')
      book('sample').should === book('sample_dup')
    end
  end
  
  describe "#exists?" do
    it "should return whether or not the file exists" do
      book('sample').should exist
      book('foo').should_not exist
    end
  end
  
  describe "#name" do
    it "should give the base name for a path" do
      book('foo').name.should == 'foo'
    end
  end
end