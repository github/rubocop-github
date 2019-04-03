# RuboCop Standard [![Build Status](https://travis-ci.org/github/rubocop-standard.svg?branch=master)](https://travis-ci.org/github/rubocop-standard)

This repository provides recommended RuboCop configuration and additional Cops for use, based initially on GitHub open source and internal Ruby projects.

## Installation

**Gemfile**

``` ruby
gem "rubocop-standard"
```

**.rubocop.yml**

``` yaml
inherit_gem:
  rubocop-standard:
    - config/default.yml
    - config/rails.yml
```

## The Cops

All cops are located under [`lib/rubocop/cop/standard`](lib/rubocop/cop/standard), and contain examples/documentation.
