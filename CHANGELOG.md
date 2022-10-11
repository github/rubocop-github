# rubocop-github

## Unreleased

- Unset `DisabledByDefault: true` in `config/default.yml`. This will use RuboCop's choice of default cops to enable, plus our existing augmentations in `config/default.yml`. Prevents confusing behaviour where downstream consumers didn't realise that RuboCop's default cops weren't being applied. (https://github.com/github/rubocop-github/pull/119)
