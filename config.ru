# coding: utf-8
require 'rack/jekyll'
require 'yaml'
run Rack::Jekyll.new
require 'rack/ssl-enforcer'
use Rack::SslEnforcer
