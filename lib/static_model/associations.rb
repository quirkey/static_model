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

    end


    class Association
      attr_reader :klass, :name, :options, :reflection_klass, :foreign_key

      def initialize(klass, name, options = {})
        @klass = klass
        @name = name
        @options = options
        @reflection_klass = Object.const_get(@options[:class_name] || @name.to_s.classify)
        @foreign_key = @options[:foreign_key]
        define_association_methods
      end

      def define_association_methods
        raise 'Should only use descendants of Association'
      end

    end
    
    class AssociationProxy
      
      attr_reader :owner, :target, :association
      
      # [].methods.each do |m|
      #        unless m =~ /(^__|^nil\?|^send|^object_id$|class|extend|find|count|sum|average|maximum|minimum|paginate|first|last|empty?)/
      #          delegate m, :to => :target
      #        end
      #      end
      #      
      delegate :respond_to?, :to => :target
      
      def initialize(owner, association)
        @association = association
        @owner = owner 
        @target = association.reflection_klass
      end
      
      def is_association_proxy?
        true
      end
      
      private
      def method_missing(method, *args)
        if target.respond_to?(:with_scope) 
          target.__send__(:with_scope, association.construct_scope(owner, target)) do
            target.__send__(method,*args)
          end
        else
          target.__send__(method,*args)
        end
      end
      
    end
    
    class HasManyAssociation < Association

      def define_association_methods
        association = self
        klass.module_eval <<-EOT
          def #{name}
            AssociationProxy.new(self, self.class.associations[:#{name}])
          end
        EOT
        # if reflection_klass.respond_to?(:scoped)
        #   klass.module_eval <<-EOT
        #     def #{name}
        #       #{reflection_klass}.scoped(:conditions => {:#{foreign_key} => id})
        #     end
        #   EOT
        # else
        #   klass.module_eval <<-EOT
        #   def #{name}
        #     #{reflection_klass}.send(:find_all_by_#{foreign_key}, id)
        #   end
        #   EOT
        # end
      end
      
      def find
        
      end
      
      def construct_scope(owner, target)
        {:find => {:conditions => {foreign_key.to_sym => owner.id}}, :create => {foreign_key.to_sym => owner.id}}
      end
    end

  end
end