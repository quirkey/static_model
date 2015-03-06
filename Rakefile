%w[rubygems rake psych rake/clean rake/testtask fileutils].each { |f| require f }
require File.dirname(__FILE__) + '/lib/static_model'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = %q{static_model}
    s.version = StaticModel::VERSION
    s.email = %{aaron@quirkey.com}
    s.homepage = "http://github.com/quirkey/static_model"
    s.authors = ["Aaron Quint"]
    s.summary = 'ActiveRecord like functionalities for reading from YAML with a simple class implementation'
    s.description   = %q{StaticModel provides a Base class much like ActiveRecord which supports reading from a YAML file and basic associations to ActiveRecord}
    s.rubyforge_project = %q{quirkey}
    s.add_development_dependency(%q<appraisal>, ["~>1.0", ">= 1.0.2"])
    s.add_development_dependency(%q<mocha>, ["~> 1.1", ">= 1.1.0"])
    s.add_development_dependency(%q<rake>, ["~>10.4", ">= 10.4.2"])
    s.add_development_dependency(%q<rails>, [">= 2.3.2", "< 3"])
    s.add_development_dependency(%q<rubigen>, [">= 1.5.7"])
    s.add_development_dependency(%q<shoulda-context>, ["~> 1.2"])
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

Rake::TestTask.new do |t|
  should_test_generator = ENV["TEST_GENERATOR"] == "true"
  t.libs << "test"
  files = FileList["test/**/*_test.rb"].delete_if { |f| !should_test_generator && f == "test/generator_test.rb" }
  t.test_files = files
  t.verbose = true
end

Dir['tasks/**/*.rake'].each { |t| load t }

task :default => :test
