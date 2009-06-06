# run with:  thin --rackup config.ru -p 4567 start

#use Rack::Static, :urls => ["/stylesheets"], :root => "public"

require 'app'

use Rack::Lint
#use Rack::Codehighlighter, :prettify, :logging => true

#use Rack::Codehighlighter, :coderay, :logging => true
#use Rack::Codehighlighter, :syntax, :logging => true

use Rack::Codehighlighter, :ultraviolet, :theme => 'dawn', :logging => true, :pattern => '//pre'

run Sinatra::Application
