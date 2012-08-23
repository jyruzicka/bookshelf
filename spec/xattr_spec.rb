require './spec/spec_helper'

include Bookshelf

describe XAttr do
  describe "#initialize" do
    it "should make an empty xattr by default" do
      empty_string = '00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
      XAttr.new.to_s.should == empty_string
      XAttr.new('foo').to_s.should == empty_string
    end
    
    it "should successfully regexp out values" do
      valid_xattr = '0C 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00'
      XAttr.new(valid_xattr)[0].should == '0C'
    end
  end
end