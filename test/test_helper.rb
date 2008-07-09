require 'test/unit'
require 'rubygems'
require 'shoulda'

require File.dirname(__FILE__) + '/../lib/static_model'

class Book < StaticModel::Base
  set_data_file File.join(File.dirname(__FILE__), 'books.yml')
end
