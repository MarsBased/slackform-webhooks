require 'rack'
require 'rack/contrib'
require_relative './app'

set :root, File.dirname(__FILE__)
run Sinatra::Application
