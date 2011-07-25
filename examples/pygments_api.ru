$:.unshift File.dirname(__FILE__)
require 'app'

use Rack::ShowExceptions
use Rack::Lint

use Rack::Codehighlighter, :pygments_api, :element => "pre",
   :pattern => /\A:::([-_+\w]+)\s*\n/, :logging => true

run Sinatra::Application