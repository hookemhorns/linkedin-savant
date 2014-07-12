require 'bundler'
Bundler.require
require 'active_support/all'

$: << File.dirname(__FILE__)

ENV['RACK_ENV'] ||= 'development'

require 'dream_on'
run DreamOn::App

