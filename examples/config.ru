# run with:  thin --rackup config.ru -p 4567 start

#use Rack::Codehighlighter, :coderay
#use Rack::Codehighlighter, :syntax
#use Rack::Codehighlighter, :ultraviolet, :theme => 'espresso_libre'
#use Rack::Static, :urls => ["/stylesheets"], :root => "public"

require 'app'

use Rack::Lint

use Rack::Codehighlighter, :prettify, :logging => true
run Sinatra::Application
