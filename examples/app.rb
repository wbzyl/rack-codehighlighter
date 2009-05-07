# -*- coding: utf-8 -*-

require 'rubygems'
require 'sinatra'
require 'rdiscount'
require 'sinatra/rdiscount'
require 'codehighlighter-middleware'

require 'coderay'                 # Coderay
#require 'syntax/convertors/html' # Syntax
#require 'uv'                     # Ultraviolet

get "/" do
  rdiscount :index
end
