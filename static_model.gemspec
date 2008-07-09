(in /Users/aaronquint/Sites/static_model)
Gem::Specification.new do |s|
  s.name = %q{static_model}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Aaron Quint"]
  s.date = %q{2008-07-09}
  s.description = %q{ActiveRecord like functionalities for reading from YAML with a simple class implementation}
  s.email = ["aaron@quirkey.com"]
  s.extra_rdoc_files = ["History.txt", "License.txt", "Manifest.txt", "README.txt"]
  s.files = ["History.txt", "License.txt", "Manifest.txt", "README.txt", "Rakefile", "config/hoe.rb", "config/requirements.rb", "lib/static_model.rb", "lib/static_model/base.rb", "lib/static_model/errors.rb", "lib/static_model/rails.rb", "lib/static_model/version.rb", "setup.rb", "test/books.yml", "test/test_helper.rb", "test/test_static_model.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://quirkey.rubyforge.org}
  s.post_install_message = %q{}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{quirkey}
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{ActiveRecord like functionalities for reading from YAML with a simple class implementation}
  s.test_files = ["test/test_helper.rb", "test/test_static_model.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
    else
    end
  else
  end
end
