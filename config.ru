# coding: utf-8
require 'rack/jekyll'
require 'yaml'
require 'rack-ssl-enforcer'

use Rack::SslEnforcer, :except_environments => 'development' # before `run Rack::Jekyll.new`
run Rack::Jekyll.new
