# RuboCop Standard

This repository enables all the recommended RuboCop configurations, but disables the overly aggressive ones.

## What's "overly aggressive"?

You know, all the ones about line length, method complexity, requiring documentation, etc.

## Installation

### Gemfile

``` ruby
gem "rubocop-standard"
```

### .rubocop.yml

``` yaml
require:
  - rubocop-standard
```
