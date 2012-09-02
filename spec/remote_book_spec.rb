require './spec/spec_helper'
=begin
module Bookshelf
  class RemoteBook
    attr_accessor :absolute_path

    def self.all
      glob = File.join(Bookshelf::remote_folder,'**','*')
      Dir[glob].map{ |p| new(p) }
    end

    def initialize path
      @absolute_path = path
    end

    def relative_path
      @relative_path ||= absolute_path.sub(/^#{Bookshelf::remote_folder}\/?/,'')
    end

    def sync!
      local_book = File.join(Bookshelf::local_folder, relative_path)

      if File.exists?(local_book) && !FileUtils.cmp(absolute_path, local_book)
        if File.mtime(absolute_path) > File.mtime(local_book)
          FileUtils::cp absolute_path, local_book
        else
          FileUtils::cp local_book, absolute_path
        end
      end
    end
  end
end
=end
include Bookshelf

describe RemoteBook do

  before :all do
    set_test_location
  end

  before :each do
    populate_working
  end

  def make_remote filename
    full_file = File.join(Bookshelf::remote_folder, filename)
    touch full_file
  end

  def make_local filename
    full_file = File.join(Bookshelf::local_folder, filename)
    touch full_file
  end

  def touch file
    FileUtils::touch file
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
end