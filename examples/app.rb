path = File.expand_path("../lib")
$:.unshift(path) unless $:.include?(path)

require 'rubygems'
require 'sinatra'

require 'rack/codehighlighter'

require 'coderay'                # Coderay
require 'syntax/convertors/html' # Syntax
require 'uv'                     # Ultraviolet

get "/" do
  erb :index
end
