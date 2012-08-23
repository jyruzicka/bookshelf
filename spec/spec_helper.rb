Dir['./lib/prelim/*.rb'].each{ |f| require f }
Dir['./lib/*.rb'].each{ |f| require f }
require 'fileutils'

def spec_data *args
  File.join('./spec', 'data', *args)
end