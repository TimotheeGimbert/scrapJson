require 'bundler'
Bundler.require

$:.unshift File.expand_path('./..', __FILE__)
require '/lib/app/file01'
require '/lib/views/file01'

binding.pry
