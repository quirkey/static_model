# Naive fallbacks for ActiveSupport String extensions. Uses ActiveSupport if its
# available, otherwise, use these so at least it doesnt require AS and its a
# little faster for the common case
class String

    unless method_defined?(:foreign_key)
      def foreign_key
        self.gsub(/^.*::/, '').underscore + "_id"
      end

      def classify
        self.gsub(/.*\./, '').singularize.camelize
      end

      def camelize
        self.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
      end

      def singularize
        self.gsub(/s$/, '')
      end

      def tableize
        self.underscore.pluralize
      end

      def pluralize
        self + "s"
      end

      def underscore
        self.gsub(/::/, '/').
          gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
          gsub(/([a-z\d])([A-Z])/,'\1_\2').
          tr("-", "_").
          downcase
      end
    end

end
