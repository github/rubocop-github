# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'rubocop-standard'
  s.version = '5.0.0'
  s.authors = ['Garen Torikian']
  s.email = ['gjtorikian@gmail.com']
  s.summary = 'RuboCop Standard'
  s.description = 'Just enables all the RuboCop recommendations'
  s.homepage = 'https://github.com/gjtorikian/rubocop-standard'
  s.license = 'MIT'

  s.files = Dir['README.md', 'LICENSE.txt', 'config/*.yml']

  s.add_dependency 'rubocop'
  s.add_dependency 'rubocop-minitest'
  s.add_dependency 'rubocop-performance'
  s.add_dependency 'rubocop-rails'

  s.add_development_dependency 'rake'
end
