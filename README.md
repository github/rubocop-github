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

## How to use it?

In your .rubocop.yml file, just write:

```yaml
inherit_gem:
  rubocop-standard:
    - config/default.yml
```

By default, `rubocop-performance` and `rubocop-rake` rules are enforced, because it's assumed that every project cares about these two sets.

This gem also has `rubocop-minitest` and `rubocop-rails` as dependencies, so you can simply add those in when you care about them:

```yaml
inherit_gem:
  rubocop-standard:
    - config/default.yml
    - config/minitest.yml
    - config/rails.yml
```
