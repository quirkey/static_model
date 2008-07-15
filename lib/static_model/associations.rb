module StaticModel
  module Associations
   
    def self.included(klass)
      klass.extend MacroMethods
    end
    
    module MacroMethods
      
      def associations
        @associations ||= {}
      end
      
      def has_many(association_name, options = {})
        self.associations[association_name.to_sym] = HasManyAssociation.new(self, association_name.to_sym, {:foreign_key => "#{self.to_s.downcase}_id"}.merge(options))
      end 
      
    end
   
    
    class Association
      attr_reader :klass, :name, :options
      
      def initialize(klass, name, options = {})
        @klass = klass
        @name = name
        @options = options
        @class_name = @options[:class_name] || @name.to_s.gsub(/s$/,'').capitalize
        @foreign_key = @options[:foreign_key]
        define_association_methods
      end
      
      def define_association_methods
        raise 'Should only use descendants of Association'
      end
      
    end
    
    class HasManyAssociation < Association
      
      def define_association_methods
        @klass.module_eval <<-EOT
          def #{@name}
            #{@class_name}.send(:find_all_by_#{@foreign_key}, id)
          end
        EOT
      end
    end
     
  end
end