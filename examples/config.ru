require 'app'

use Rack::ShowExceptions
use Rack::Lint

#use Rack::Codehighlighter, :prettify, :element => "//pre", :pattern => /\A:::(\w+)\s*\n/, :logging => true

#use Rack::Codehighlighter, :coderay,  :element => "//pre", :pattern => /\A:::(\w+)\s*\n/, :logging => true

#use Rack::Codehighlighter, :syntax,   :element => "//pre", :pattern => /\A:::(\w+)\s*\n/, :logging => true

use Rack::Codehighlighter, :ultraviolet, :theme => 'dawn',
                                       :element => "//pre", :pattern => /\A:::(\w+)\s*\n/, :logging => true

#use Rack::Codehighlighter, :censor, :reason => '[[-- ugly code --]]'

run Sinatra::Application
