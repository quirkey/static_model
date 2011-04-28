begin
  require 'rubigen'
rescue => LoadError
  warn "Please install rubigen"
end

class StaticModelGenerator < RubiGen::Base

  default_options :author => nil

  attr_reader :name, :lib_dir, :data_dir

  def initialize(runtime_args, runtime_options = {})
    super
    usage if args.empty?
    @name = args.shift
    extract_options
  end

  def manifest
    record do |m|
      # Ensure appropriate folder(s) exists
      m.directory data_dir
      m.directory lib_dir
      m.template 'model.rb.erb', File.join(lib_dir, name.underscore + ".rb")
      m.template 'models.yml.erb', File.join(data_dir, table_name + ".yml")
    end
  end

  protected
    def banner
      <<-EOS
Creates a ...

USAGE: #{$0} #{spec.name} ModelName
EOS
    end

    def class_name
      @name.classify
    end

    def table_name
      @name.tableize
    end

    def add_options!(opts)
      # opts.separator ''
      # opts.separator 'Options:'
      # For each option below, place the default
      # at the top of the file next to "default_options"
      # opts.on("-a", "--author=\"Your Name\"", String,
      #         "Some comment about this option",
      #         "Default: none") { |options[:author]| }
      opts.on("-l", "--lib=your/path/", String, "Put the model.rb in a specific lib dir (default = app/models/)") {|o| options[:lib_dir] = o }
      opts.on("-d", "--data=your/path/", String, "Put the models.yml data file in a specific data dir (default = config/data/)") {|o| options[:data_dir] = o }
    end

    def extract_options
      @lib_dir = options[:lib_dir] || File.join('app', 'models')
      @data_dir = options[:data_dir] || File.join('config', 'data')
    end
end
