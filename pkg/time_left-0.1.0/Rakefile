require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('time_left', '0.1.0') do |p|
  p.description    = "Print out time left doing some process"
  p.url            = ""
  p.author         = "Artur Meisters"
  p.email          = "arturs.meisters@gmail.com"
  p.ignore_pattern = ["tmp/*", "script/*"]
  p.development_dependencies = []
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }
