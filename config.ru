require 'rubygems'
require 'bundler'
Bundler.require

$LOAD_PATH.unshift 'lib'
require 'bot'
run Books::Bot
