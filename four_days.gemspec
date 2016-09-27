$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "four_days/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "four_days"
  s.version     = FourDays::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["zzbazza"]
  s.email       = ["jlafek@seznam.cz"]
  s.homepage    = "https://github.com/topmonks/four_days"
  s.summary     = "app generator"
  s.description = "app generator"
  s.license     = "MIT"

  s.executables << 'four_days'
  s.executables << 'four_days_template'
  s.executables << 'four_days_cleanup'
  s.files = Dir["lib/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.require_paths = ["lib"]

  s.add_dependency "rails", "~> 5.0.0", "< 5.1"
end