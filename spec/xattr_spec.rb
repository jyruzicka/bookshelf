require './spec/spec_helper'


include Bookshelf

describe XAttr do
  before :each do
    populate_working
  end

  let(:coloured_file){ spec_data('local/sample')}
  let(:uncoloured_file){ spec_data('local/uncoloured')}

  describe "#[]" do
    it "should collect the right amount of data, regardless" do
      XAttr[coloured_file].size.should == 32
    end

    it "should actually collect data" do
      XAttr[coloured_file][9].should == '0C'
      XAttr[uncoloured_file][9].should == '00'
    end
  end

  describe "#in" do
    it "should collect all coloured files" do
      # I have no idea why I need to sleep here, but hey
      sleep 2
      coloured = XAttr.in spec_data('local')
      coloured.size.should == 1
      File.basename(coloured[0]).should == 'sample'
    end
  end


  describe "#flagged?" do
    it "should detect flagged files" do
      XAttr.flagged?(coloured_file).should be_true
      XAttr.flagged?(uncoloured_file).should_not be_true
    end
  end

  describe "#unflag!" do
    it "should unflag files" do
      XAttr.flagged?(coloured_file).should be_true
      XAttr.unflag!(coloured_file)
      XAttr.flagged?(coloured_file).should be_false
    end
  end
end