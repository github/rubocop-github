
# RuboCop GitHub

This repository provides recommended RuboCop configuration and additional Cops for use on GitHub open source and internal Ruby projects.

## Installation

**Gemfile**

``` ruby
gem "rubocop-github"
```

**.rubocop.yml**

``` yaml
inherit_gem:
  rubocop-github:
    - config/default.yml
    - config/rails.yml
```

## The Cops

All cops are located under [`lib/rubocop/cop/github`](lib/rubocop/cop/github), and contain examples/documentation.
