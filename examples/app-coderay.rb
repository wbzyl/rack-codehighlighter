path = File.expand_path("../lib")
$:.unshift(path) unless $:.include?(path)

require 'rubygems'
require 'sinatra'

require 'rack/codehighlighter'

require 'coderay'                # Coderay

get "/" do
  erb :index
end
