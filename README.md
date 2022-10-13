# RuboCop GitHub ![CI](https://github.com/github/rubocop-github/workflows/CI/badge.svg?event=push)

This repository provides recommended RuboCop configuration and additional Cops for use on GitHub open source and internal Ruby projects.

## Usage

Add `rubocop-github` to your Gemfile, along with its dependencies:

  ```ruby
  gem "rubocop-github", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
  ```

Inherit all of the stylistic rules and cops through an inheritance declaration in your `.rubocop.yml`:

  ```yaml
  # .rubocop.yml
  inherit_from:
    rubocop-github:
      - config/default.yml # generic Ruby rules and cops
      - config/rails.yml # Rails-specific rules and cops
  ```

Alternatively, only require the additional custom cops in your `.rubocop.yml` without inheriting/enabling the other stylistic rules:

  ```yaml
  # .rubocop.yml
  require:
    - rubocop-github  # generic Ruby cops only
    - rubocop-github-rails # Rails-specific cops only
  ```

💭 Looking for `config/accessibility.yml` and the `GitHub/Accessibility` configs? They have been moved to [a new gem](https://github.com/github/rubocop-rails-accessibility).

### Legacy usage

If you are using a rubocop version < 1.0.0, you can use rubocop-github version
0.16.2 (see the README from that version for more details).

## Testing

``` bash
bundle install
bundle exec rake test
```

## The Cops

All cops are located under [`lib/rubocop/cop/github`](lib/rubocop/cop/github).
