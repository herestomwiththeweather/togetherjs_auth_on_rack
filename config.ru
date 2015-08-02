$:.push(File.dirname(__FILE__)+'/lib')
require 'cyber'

use Rack::Reloader, 0

puts $:

run Rack::Cascade.new([Rack::File.new("public"), Cyber])
