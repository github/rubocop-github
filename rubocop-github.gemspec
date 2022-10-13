# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = "rubocop-github"
  s.version = "0.19.0"
  s.summary = "RuboCop GitHub"
  s.description = "Code style checking for GitHub Ruby repositories "
  s.homepage = "https://github.com/github/rubocop-github"
  s.license = "MIT"

  s.files = Dir["README.md", "STYLEGUIDE.md", "LICENSE", "config/*.yml", "lib/**/*.rb", "guides/*.md"]

  s.add_dependency "rubocop", ">= 1.0.0"
  s.add_dependency "rubocop-performance"
  s.add_dependency "rubocop-rails"

  s.add_development_dependency "actionview"
  s.add_development_dependency "minitest"
  s.add_development_dependency "rake"

  s.required_ruby_version = ">= 2.5.0"

  s.email = "engineering@github.com"
  s.authors = "GitHub"
end
