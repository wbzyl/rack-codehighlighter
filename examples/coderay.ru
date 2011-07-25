$:.unshift File.dirname(__FILE__)
require 'app'

use Rack::ShowExceptions
use Rack::Lint

require 'coderay'
use Rack::Codehighlighter, :coderay, :element => "pre", :pattern => /\A:::(\w+)\s*\n/, :logging => true

run Sinatra::Application
