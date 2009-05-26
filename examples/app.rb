# -*- coding: utf-8 -*-

path = File.join(File.expand_path(File.dirname(__FILE__)), "..", "lib")
$:.unshift(path) unless $:.include?(path)

require 'rubygems'
require 'sinatra'
require 'rdiscount'

gem 'wbzyl-sinatra-rdiscount'
require 'sinatra/rdiscount'

require 'codehighlighter-middleware'

require 'coderay'                 # Coderay
#require 'syntax/convertors/html' # Syntax
#require 'uv'                     # Ultraviolet

get "/" do
  rdiscount :index
end
