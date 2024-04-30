# frozen_string_literal: true

$LOAD_PATH.push(File.expand_path("lib", __dir__))
require "rubocop-standard/version"

Gem::Specification.new do |s|
  s.name = "rubocop-standard"
  s.version = RubocopStandard::VERSION
  s.authors = ["Garen Torikian"]
  s.email = ["gjtorikian@gmail.com"]
  s.summary = "Enhanced RuboCop configurations"
  s.description = "Enables Shopify’s Ruby Style Guide recommendations (and bundles them with other niceties, like `rubocop-{minitest,performance,rails,rake}`)."
  s.homepage = "https://github.com/gjtorikian/rubocop-standard"
  s.license = "MIT"

  s.files = Dir["README.md", "LICENSE.txt", "config/*.yml"]
  s.required_ruby_version = ">= 2.7", "< 4.0"

  s.add_dependency("rubocop")

  s.add_dependency("rubocop-minitest")
  s.add_dependency("rubocop-performance")
  s.add_dependency("rubocop-rails")
  s.add_dependency("rubocop-rails-accessibility")
  s.add_dependency("rubocop-rake")
  s.add_dependency("rubocop-shopify")
  s.add_dependency("rubocop-sorbet")

  s.add_development_dependency("rake")

  s.metadata["rubygems_mfa_required"] = "true"
end
