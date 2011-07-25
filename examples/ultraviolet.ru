$:.unshift File.dirname(__FILE__)
require 'app'

use Rack::ShowExceptions
use Rack::Lint

require 'uv'
use Rack::Codehighlighter, :ultraviolet, 
  :element => "pre", :pattern => /\A:::(\w+)\s*\n/,
  :themes => {"cobalt" => ["ruby"], "zenburnesque" => ["c", "sql"]},
  :logging => true

run Sinatra::Application
