require 'bundler'
Bundler.require

$:.unshift File.expand_path('./../lib', __FILE__)
require 'app/scraper'
#require '/views/file01'

scrap = Scraper.new.perform
