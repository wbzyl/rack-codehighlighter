$:.unshift File.dirname(__FILE__)
require 'app'

use Rack::ShowExceptions
use Rack::Lint

require 'syntax/convertors/html'
use Rack::Codehighlighter, :syntax, :element => "pre", :pattern => /\A:::([-_+\w]+)\s*\n/, :logging => true

run Sinatra::Application