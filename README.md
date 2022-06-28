# RuboCop GitHub ![CI](https://github.com/github/rubocop-github/workflows/CI/badge.svg?event=push)

This repository provides recommended RuboCop configuration and additional Cops for use on GitHub open source and internal Ruby projects.

## Usage

**Gemfile**

``` ruby
gem "rubocop-github"
gem "rubocop-performance", require: false
gem "rubocop-rails", require: false
```

**.rubocop.yml**

``` yaml
inherit_gem:
  rubocop-github:
    - config/default.yml
    - config/rails.yml
```

### Legacy usage

If you are using a rubocop version < 1.0.0, you can use rubocop-github version
0.16.2 (see the README from that version for more details).

## Testing

`bundle install`
`bundle exec rake test`

## The Cops

All cops are located under [`lib/rubocop/cop/github`](lib/rubocop/cop/github), and contain examples/documentation.
