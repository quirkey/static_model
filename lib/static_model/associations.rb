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
        self.associations[association_name.to_sym] = HasManyAssociation.new(self, association_name.to_sym, {:foreign_key => "#{self.to_s.foreign_key}"}.merge(options))
      end

      def belongs_to(association_name, options = {})
        self.associations[association_name.to_sym] = BelongsToAssociation.new(self, association_name.to_sym, {:foreign_key => "#{association_name.to_s.foreign_key}"}.merge(options))
      end

    end


    class Association
      attr_reader :klass, :name, :options, :foreign_key

      def initialize(klass, name, options = {})
        @klass = klass
        @name = name
        @options = options
        @reflection_klass_name = @options[:class_name] || @name.to_s.classify
        @foreign_key = @options[:foreign_key]
        define_association_methods
      end

      def reflection_klass
        Object.const_get(@reflection_klass_name)
      rescue
        eval <<-EOT
          class #{@reflection_klass_name}; end;
          #{@reflection_klass_name}
        EOT
      end

      def define_association_methods
        raise 'Should only use descendants of Association'
      end
    end

    class HasManyAssociation < Association

      def define_association_methods
        if reflection_klass.respond_to?(:scoped)
          klass.module_eval <<-EOT
            def #{name}
              #{reflection_klass}.scoped(:conditions => {:#{foreign_key} => id})
            end
          EOT
        else
          klass.module_eval <<-EOT
          def #{name}
            #{reflection_klass}.send(:find_all_by_#{foreign_key}, id)
          end
          EOT
        end
      end
    end

    class BelongsToAssociation < Association

      def define_association_methods
        klass.module_eval <<-EOT
          def #{name}
            #{reflection_klass}.send(:find, #{foreign_key})
          end
        EOT
      end
    end

  end
end
