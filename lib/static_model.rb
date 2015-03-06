$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'yaml' unless defined?(YAML)
require 'erb'  unless defined?(ERB)

module StaticModel
  VERSION = '1.1.0'
end

require 'static_model/active_support'
require 'static_model/errors'
require 'static_model/associations'
require 'static_model/active_record'
require 'static_model/comparable'
require 'static_model/base'
