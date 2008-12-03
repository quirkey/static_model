Gem::Specification.new do |s|
  s.name = %q{static_model}
  s.version = "0.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Aaron Quint"]
  s.date = %q{2008-12-03}
  s.description = %q{ActiveRecord like functionalities for reading from YAML with a simple class implementation}
  s.email = ["aaron@quirkey.com"]
  s.extra_rdoc_files = ["History.txt", "License.txt", "Manifest.txt"]
  s.files = ["History.txt", "License.txt", "Manifest.txt", "README.rdoc", "generators/static_model/USAGE", "generators/static_model/static_model_generator.rb", "generators/static_model/templates/model.rb.erb", "generators/static_model/templates/models.yml.erb", "lib/static_model.rb", "lib/static_model/active_record.rb", "lib/static_model/associations.rb", "lib/static_model/base.rb", "lib/static_model/comparable.rb", "lib/static_model/errors.rb", "lib/static_model/rails.rb", "lib/static_model/scope.rb", "lib/static_model/version.rb", "test/test_generator_helper.rb", "test/test_helper.rb", "test/test_static_model.rb", "test/test_static_model_associations.rb", "test/test_static_model_generator.rb", "test/test_static_model_scope.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://quirkey.rubyforge.org}
  s.post_install_message = %q{}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{quirkey}
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{ActiveRecord like functionalities for reading from YAML with a simple class implementation}
  s.test_files = ["test/test_generator_helper.rb", "test/test_helper.rb", "test/test_static_model.rb", "test/test_static_model_associations.rb", "test/test_static_model_generator.rb", "test/test_static_model_scope.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
      s.add_runtime_dependency(%q<activesupport>, [">= 2.1.0"])
      s.add_development_dependency(%q<hoe>, [">= 1.8.2"])
    else
      s.add_dependency(%q<activesupport>, [">= 2.1.0"])
      s.add_dependency(%q<hoe>, [">= 1.8.2"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 2.1.0"])
    s.add_dependency(%q<hoe>, [">= 1.8.2"])
  end
end
