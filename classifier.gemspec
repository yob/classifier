Gem::Specification.new do |spec|
  spec.name = "classifier"
  spec.version = "0.0.1"
  spec.summary = "a basic bayesian classification library"
  spec.description = "a basic bayesian classification library - built to teach myself, not for production"
  spec.license = "MIT"
  spec.author = "James Healy"
  spec.email = "james@yob.id.au"
  spec.homepage = "http://github.com/yob/classifier"
  spec.has_rdoc = true
  spec.rdoc_options << "--title" << "Clasifier" << "--line-numbers"

  spec.required_ruby_version = ">=2.0"

  spec.test_files = Dir.glob("spec/**/*_spec.rb")
  spec.files = Dir.glob("lib/**/*.rb") + 
                Dir.glob("bin/*") + 
                ["MIT-LICENSE", "README.markdown"]

  spec.add_development_dependency("rake")
  spec.add_development_dependency("rspec", "~> 3.0")
  spec.add_development_dependency("sequel", "~> 4.0")
  spec.add_development_dependency("pg", "~> 0.19")
  spec.add_development_dependency("pry")
end
