require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('time_left', '0.1.2') do |p|
  p.description    = "Print out time that left doing some process"
  p.url            = ""
  p.author         = "Artur Meisters"
  p.email          = "arturs@ithouse.lv"
  p.ignore_pattern = ["tmp/*", "script/*"]
  p.development_dependencies = []
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }
