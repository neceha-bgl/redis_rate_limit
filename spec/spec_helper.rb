$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "simplecov"
require 'fakeredis'
require 'pry'
require 'timecop'
require "redis_rate_limit"
