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
        @reflection_class = Object.const_get(@options[:class_name] || @name.to_s.gsub(/s$/,'').capitalize)
        @foreign_key = @options[:foreign_key]
        define_association_methods
      end

      def define_association_methods
        raise 'Should only use descendants of Association'
      end

    end

    class HasManyAssociation < Association

      def define_association_methods
        if @reflection_class.respond_to?(:scoped)
          @klass.module_eval <<-EOT
            def #{@name}
              #{@reflection_class}.scoped(:conditions => {:#{@foreign_key} => id})
            end
          EOT
        else
          @klass.module_eval <<-EOT
          def #{@name}
            #{@reflection_class}.send(:find_all_by_#{@foreign_key}, id)
          end
          EOT
        end
      end
    end

  end
end