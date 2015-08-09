$:.push(File.dirname(__FILE__)+'/lib')
require 'user'
require 'cyber'

ActiveRecord::Base.establish_connection 'sqlite3://./db/db.sqlite3'

use Rack::Reloader, 0
use Rack::Session::Cookie, key: 'tjs-session',
                           #secret: ENV['SESSION_SECRET'],
                           secret: '95f2cbc331ffbfdda097fb56bb376fd3',
                           expire_after: 30*24*60*60

puts $:

run Rack::Cascade.new([Rack::File.new("public"), Cyber])
