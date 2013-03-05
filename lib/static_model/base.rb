module StaticModel
  class Base
    include StaticModel::Associations
    include StaticModel::ActiveRecord
    include StaticModel::Comparable

    def self.load_path
      @@load_path ||= File.join('config', 'data')
    end

    def self.load_path=(path)
      @@load_path = path
    end

    attr_reader :id

    def initialize(attribute_hash = {}, force_load = true)
      self.class.load if force_load
      raise(StaticModel::BadOptions, "Initializing a model is done with a Hash {} given #{attribute_hash.inspect}") unless attribute_hash.is_a?(Hash)
      @id = attribute_hash.delete('id') || attribute_hash.delete(:id) || self.class.next_id
      self.attributes = attribute_hash
      self.class.last_id = @id
    end

    def to_s
      "<#{self.class} #{@attributes.inspect}>"
    end

    def self.attribute(name, options = {})
      options = {
        :default => nil,
        :freeze => false
      }.merge(options)
      @defined_attributes ||= {}
      @defined_attributes[name.to_s] = options

      module_eval <<-EOT
        def #{name}
          @attributes['#{name}'] || #{options[:default].inspect}
        end

        def #{name}=(value)
          if !#{options[:freeze].inspect}
            @attributes['#{name}'] = value
          end
        end

        def #{name}?
          !!#{name}
        end
      EOT
    end

    def self.defined_attributes
      @defined_attributes || {}
    end

    def attributes
      @attributes ||= {}
    end

    def attributes=(attribute_hash)
      attribute_hash.each {|k,v| set_attribute(k,v) }
    end

    def attribute_names
      (attributes.keys | self.class.class_attributes.keys | self.class.defined_attributes.keys).collect {|k| k.to_s }
    end

    def has_attribute?(name)
      name.to_s == 'id' || attribute_names.include?(name.to_s)
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

      def find_last
        records[records.length-1]
      end
      alias_method :last, :find_last

      def find_all_by(attribute, value)
        records.find_all {|r| r.has_attribute?(attribute) ? (r.send(attribute) == value) : false }
      end

      def find_first_by(attribute, value)
        records.find {|r| r.has_attribute?(attribute) ? (r.send(attribute) == value) : false }
      end
      alias_method :find_by, :find_first_by

      def find_last_by(attribute, value)
        records.reverse.find {|r| r.has_attribute?(attribute) ? (r.send(attribute) == value) : false }
      end

      def load(reload = false)
        return if loaded? && !reload
        begin
          raw_data = File.open(data_file) {|f| f.read }
          parsed_data = ERB.new(raw_data).result
          data = YAML::load(parsed_data)
        rescue
          raise(StaticModel::BadDataFile, "The data file you specified '#{data_file}' was not in a readable format.")
        end
        records = []
        if data.is_a?(Hash) && data.has_key?('records')
          records = data.delete('records')
          @class_attributes = data
          @class_attributes.make_indifferent! if @class_attributes.respond_to?(:make_indifferent!)
        elsif data.is_a?(Array)
          records = data
        end
        @last_id = 0
        @records = records && !records.empty? ? records.dup.collect {|r| new(r, false) } : []
        @loaded = true
      end

      def reload!
        load(true)
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
        # force reload
        @loaded = false
        @records = nil
      end

      def count
        records.length
      end

      def class_attributes
        load
        @class_attributes ||= {}
      end

      def class_attribute(name)
        class_attributes[name]
      end

      def records
        load
        @records
      end

      def next_id
        last_id + 1
      end

      def last_id
        @last_id ||= 0
      end

      def last_id=(new_last_id)
        @last_id = new_last_id if new_last_id > self.last_id
      end

      protected
      def default_data_file_path
        File.join(self.load_path, "#{self.to_s.tableize}.yml")
      end

      private
      def method_missing(meth, *args)
        meth_name = meth.to_s
        if meth_name =~ /^find_(all_by|first_by|last_by|by)_(.+)/
          attribute_name = meth_name.gsub(/^find_(all_by|first_by|last_by|by)_/, '')
          finder    = meth_name.gsub(/_#{attribute_name}/, '')
          return self.send(finder, attribute_name, *args)
        elsif class_attributes.has_key? meth_name
          return class_attributes[meth_name]
        end
        super
      end

      def respond_to_missing?(meth, *args)
        meth_name = meth.to_s
        if meth_name =~ /^find_(all_by|first_by|last_by|by)_(.+)/
          attribute_name = meth_name.gsub(/^find_(all_by|first_by|last_by|by)_/, '')
          return true if has_attribute?(attribute_name)
        end
        class_attributes.has_key?(meth_name) || super
      end
    end

    protected
    def set_attribute(name, value)
      self.attributes[name.to_s] = value
    end

    def get_attribute(name)
      attributes.has_key?(name) ? attributes[name] : self.class.class_attribute(name)
    end

    private
    def method_missing(meth, *args)
      attribute_name = meth.to_s.gsub(/=$/,'')
      if has_attribute?(attribute_name)
        if meth.to_s =~ /=$/
          # set
          return set_attribute(attribute_name, args[0])
        else
          # get
          return get_attribute(attribute_name)
        end
      end
      super
    end

    def respond_to_missing?(meth, *args)
      attribute_name = meth.to_s.gsub(/=$/,'')
      has_attribute?(attribute_name) || super
    end

  end
end
