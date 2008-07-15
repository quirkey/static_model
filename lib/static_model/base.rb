module StaticModel  
  class Base
    include StaticModel::Associations

    @@load_path = File.join('config', 'data')

    attr_reader :id

    def initialize(attribute_hash = {})
      raise(StaticModel::BadOptions, "Initializing a model is done with a Hash {}") unless attribute_hash.is_a?(Hash)
      @id = attribute_hash.delete('id') || attribute_hash.delete(:id) || (self.class.count + 1)
      self.attributes = attribute_hash
    end

    def to_s
      self.inspect
    end

    def attributes
      @attributes ||= {}
    end

    def attributes=(attribute_hash)
      attribute_hash.each {|k,v| set_attribute(k,v) }
    end

    def attribute_names
      attributes.keys
    end

    class << self

      def find(what, *args, &block)
        case what
        when Symbol
          send("find_#{what}")
        when Integer
          find_by_id(what)
        end
      end

      def find_by_id(id)
        record = records.detect {|r| r.id == id }
        raise(StaticModel::RecordNotFound, "Could not find record with id = #{id}") unless record
        record
      end

      def [](id)
        find_by_id(id)
      end

      def find_all
        records
      end
      alias_method :all, :find_all

      def find_first
        records[0]
      end
      alias_method :first, :find_first

      def find_all_by(attribute, value)
        records.find_all {|r| r.send(attribute) == value }
      end

      def find_first_by(attribute, value)
        records.find {|r| r.send(attribute) == value }
      end

      def load(reload = false)
        return if loaded? && !reload
        raise(StaticModel::DataFileNotFound, "You must set a data file to load from") unless File.readable?(data_file) 
        records = YAML::load_file(data_file)
        @records = records.dup.collect {|r| new(r) }
        @loaded = true
      end

      def loaded?
        @loaded ||= false
      end

      def data_file
        @data_file ||= default_data_file_path
      end

      def set_data_file(file_path)
        raise(StaticModel::DataFileNotFound, "Could not find data file #{file_path}") unless File.readable?(file_path)
        @data_file = file_path
      end
    
      def count
        records.length
      end
      
      def records
        load
        @records
      end

      protected
      def default_data_file_path
        File.join(@@load_path, "#{self.to_s.tableize}.yml")
      end

      private
      def method_missing(meth, *args)
        meth_name = meth.to_s
        if meth_name =~ /^find_(all|first)_by_(.+)/
          attribute_name = meth_name.gsub(/^find_(all|first)_by_/, '')
          finder    = meth_name.gsub(/_#{attribute_name}/, '')
          return self.send(finder, attribute_name, *args)
        end
        super
      end
    end  

    protected
    def set_attribute(name, value)
      self.attributes[name.to_sym] = value
    end

    private
    def method_missing(meth, *args)
      attribute_name = meth.to_s.gsub(/=$/,'').to_sym
      if attribute_names.include?(attribute_name)
        if meth.to_s =~ /=$/
          # set
          return set_attribute(attribute_name, args[0])
        else
          # get
          return attributes[attribute_name]
        end
      end
      super
    end
    
  end
end