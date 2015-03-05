$LOAD_PATH.unshift(File.join(File.expand_path(File.dirname(__FILE__)), "../lib"))

require "rubygems"
require "minitest/autorun"
require "mocha/test_unit"
require "shoulda-context"

require "static_model"

class Book < StaticModel::Base
  set_data_file File.join(File.dirname(__FILE__), 'data', 'books.yml')

  attribute :rating, :default => 3
  attribute :read, :default => false, :freeze => true
end

class BookWithInferredAttributes < StaticModel::Base
  set_data_file File.join(File.dirname(__FILE__), 'data', 'books.yml')
end

unless defined?(ActiveRecord::Base)
  module ActiveRecord
    class Base
      def self.scoped(*args)
      end
    end
  end
end

class Article < ActiveRecord::Base
end

class Publisher < StaticModel::Base
  set_data_file File.join(File.dirname(__FILE__), 'data', 'publishers.yml')

  has_many :authors
end

class Author < StaticModel::Base
  set_data_file File.join(File.dirname(__FILE__), 'data','authors.yml')
  has_many :books
  has_many :articles
  belongs_to :publisher
end

class Page < StaticModel::Base
  set_data_file File.join(File.dirname(__FILE__), 'data', 'pages.yml')

end

class Store < StaticModel::Base
  set_data_file File.join(File.dirname(__FILE__), 'data', 'stores.yml')

end

class Project < StaticModel::Base
  set_data_file File.join(File.dirname(__FILE__), 'data', 'projects.yml')
  belongs_to :author
end

class Minitest::Test

  def assert_all(collection)
    collection.each do |one|
      assert yield(one), "#{one} is not true"
    end
  end

  def assert_any(collection, &block)
    has = collection.any? do |one|
      yield(one)
    end
    assert has
  end

  def assert_ordered(array_of_ordered_items, message = nil, &block)
    raise "Parameter must be an Array" unless array_of_ordered_items.is_a?(Array)
    message ||= "Items were not in the correct order"
    i = 0
    # puts array_of_ordered_items.length
    while i < (array_of_ordered_items.length - 1)
      # puts "j"
      a, b = array_of_ordered_items[i], array_of_ordered_items[i+1]
      comparison = yield(a,b)
      # raise "#{comparison}"
      assert(comparison, message + " - #{a}, #{b}")
      i += 1
    end
  end

  def assert_set_of(klass, set)
    assert set.respond_to?(:each), "#{set} is not a set (does not include Enumerable)"
    assert_all(set) {|a| a.is_a?(klass) }
  end
end
