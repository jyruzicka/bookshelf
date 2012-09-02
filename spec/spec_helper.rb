VERBOSE = false
DRYRUN = false

require './lib/bookshelf'
require 'fileutils'

def set_test_location
  Bookshelf::local_folder = spec_data('local')
  Bookshelf::remote_folder = spec_data('remote')
  Bookshelf::file_types = nil
  FileUtils::mkdir_p spec_data('local')
  FileUtils::mkdir_p spec_data('remote')
end

def spec_data *args
  File.join('./spec', 'data', 'working', *args)
end

def clear_working
	FileUtils::rm_rf spec_data
end

def populate_working
  clear_working
	`cp -a ./spec/data/pristine '#{spec_data}'` # cp -a needed to preserve file colours
end