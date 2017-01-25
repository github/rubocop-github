Gem::Specification.new do |s|
  s.name = "rubocop-github"
  s.version = "0.3.0"
  s.summary = "RuboCop GitHub"
  s.description = "Code style checking for GitHub Ruby repositories "
  s.homepage = "https://github.com/github/rubocop-github"
  s.license = "MIT"

  s.files = Dir["README.md", "STYLEGUIDE.md", "LICENSE", "config/*.yml", "lib/**/*.rb"]

  s.add_dependency "rubocop", "~> 0.47"

  s.add_development_dependency "minitest", "~> 5.10"
  s.add_development_dependency "rake", "~> 12.0"

  s.required_ruby_version = ">= 2.1.0"

  s.email = "engineering@github.com"
  s.authors = "GitHub"
end
