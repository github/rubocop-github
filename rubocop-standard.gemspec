# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'rubocop-standard'
  s.version = '4.1.0'
  s.authors = ['Garen Torikian']
  s.email = ['gjtorikian@gmail.com']
  s.summary = 'RuboCop Standard'
  s.description = 'Code style checking for Ruby repositories, starting with GitHub defaults'
  s.homepage = 'https://github.com/gjtorikian/rubocop-standard'
  s.license = 'MIT'

  s.files = Dir['README.md', 'STYLEGUIDE.md', 'LICENSE', 'config/*.yml', 'lib/**/*.rb', 'guides/*.md']

  s.add_dependency 'rubocop'
  s.add_dependency 'rubocop-minitest'
  s.add_dependency 'rubocop-performance'
  s.add_dependency 'rubocop-rails'

  s.add_development_dependency 'actionview', '~> 5.0'
  s.add_development_dependency 'minitest', '~> 5.10'
  s.add_development_dependency 'rake', '~> 12.0'
end
