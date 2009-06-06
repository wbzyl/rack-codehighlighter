require 'app'

use Rack::ShowExceptions
use Rack::Lint

# use default options

#use Rack::Codehighlighter, :prettify, :element => "pre", :pattern => /\A:::(\w+)\s*\n/, :logging => true

use Rack::Codehighlighter, :coderay,  :element => "pre", :pattern => /\A:::(\w+)\s*\n/, :logging => true

#use Rack::Codehighlighter, :syntax,   :element => "pre", :pattern => /\A:::(\w+)\s*\n/, :logging => true

#use Rack::Codehighlighter, :ultraviolet, :theme => 'dawn',
#                                       :element => "pre", :pattern => /\A:::(\w+)\s*\n/, :logging => true

#use Rack::Codehighlighter, :censor, :reason => '[[--  ugly code removed  --]]'

run Sinatra::Application
