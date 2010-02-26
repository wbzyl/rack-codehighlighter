require 'app'

use Rack::ShowExceptions
use Rack::Lint

use Rack::Codehighlighter, :ultraviolet, 
  :element => "pre", :pattern => /\A:::(\w+)\s*\n/,
  :themes => {"cobalt" => ["ruby"], "zenburnesque" => ["c", "sql"]},
  :logging => true

run Sinatra::Application
