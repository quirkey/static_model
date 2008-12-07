module StaticModel
  module Casting
    
    def cast(attribute_name, options = {}, &block)
      to = options.delete(:to)
      raise(StaticModel::BadOptions, "cast takes either an option :to or a block") unless to || block_given?
    end
    
  end
end