# rubocop-github

## v0.23.0

- Read the automatic release notes on [the /releases page for this gem](https://github.com/github/rubocop-github/releases).

## v0.22.0

- Read the automatic release notes on [the /releases page for this gem](https://github.com/github/rubocop-github/releases).

## v0.21.0

- Added new GitHub/AvoidObjectSendWithDynamicMethod cop to discourage use of methods like Object#send

## v0.20.0

- Updated minimum dependencies for "rubocop" (`>= 1.37`), "rubocop-performance" (`>= 1.15`), and "rubocop-rails", (`>= 2.17`).

## v0.19.0

- Unset `DisabledByDefault: true` in `config/default.yml`. Prevents confusing behaviour where users of the gem didn't realise that RuboCop's default cops weren't being applied (including potentially custom cops in their projects). We've explicitly set `Enabled: false` for all the cops that were previously default disabled. This has the effect that consumers of this gem won't be surprised by new linting violations when they use this new version in their projects. (https://github.com/github/rubocop-github/pull/119)
