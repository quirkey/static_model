$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'yaml'


require 'active_support/inflector'
require 'active_support/core_ext/hash'
require 'active_support/core_ext/string'
require 'active_support/core_ext/integer'

require 'static_model/errors'
require 'static_model/associations'
require 'static_model/active_record'
require 'static_model/comparable'
require 'static_model/base'
require 'static_model/rails'