# frozen_string_literal: true

require_relative "lib/version"

Gem::Specification.new do |s|
  s.name = "rubocop-github"
  s.version = VERSION
  s.summary = "RuboCop GitHub"
  s.description = "Code style checking for GitHub Ruby repositories"
  s.homepage = "https://github.com/github/rubocop-github"
  s.license = "MIT"

  s.metadata = {
    "source_code_uri" => "https://github.com/github/rubocop-github",
    "documentation_uri" => "https://github.com/github/rubocop-github",
    "bug_tracker_uri" => "https://github.com/github/rubocop-github/issues"
  }

  s.files = Dir["README.md", "STYLEGUIDE.md", "LICENSE", "config/*.yml", "lib/**/*.rb", "guides/*.md"]

  s.required_ruby_version = ">= 3.1.0"

  s.add_dependency "rubocop", ">= 1.76"
  s.add_dependency "rubocop-performance", ">= 1.24"
  s.add_dependency "rubocop-rails", ">= 2.23"

  s.add_development_dependency "actionview", "~> 7.2.3"
  s.add_development_dependency "minitest"
  s.add_development_dependency "rake"

  s.email = "engineering@github.com"
  s.authors = "GitHub"
end
