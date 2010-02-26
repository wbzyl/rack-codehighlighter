require 'app'

use Rack::ShowExceptions
use Rack::Lint

use Rack::Codehighlighter, :censor, :reason => '[[--  ugly code removed  --]]'

run Sinatra::Application
