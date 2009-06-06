# -*- coding: utf-8 -*-

path = File.join(File.expand_path(File.dirname(__FILE__)), "..", "lib")
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
