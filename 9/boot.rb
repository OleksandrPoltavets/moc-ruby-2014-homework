require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

require 'active_support'
require 'active_support/core_ext'


Dir[File.dirname(__FILE__) + '/app/*.rb'].each {|file| require file }

