require 'app'

use Rack::ShowExceptions
use Rack::Lint

use Rack::Codehighlighter, :prettify, :element => "pre", :pattern => /\A:::(\w+)\s*\n/, :logging => true

run Sinatra::Application
