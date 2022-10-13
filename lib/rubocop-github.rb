# frozen_string_literal: true

require "rubocop"
require "rubocop/github"
require "rubocop/github/inject"

RuboCop::GitHub::Inject.default_defaults!

require "rubocop/cop/github/insecure_hash_algorithm"
