require './app-coderay'

use Rack::ShowExceptions
use Rack::Lint

use Rack::Codehighlighter, :coderay, :element => "pre", :pattern => /\A:::(\w+)\s*\n/, :logging => true

run Sinatra::Application
