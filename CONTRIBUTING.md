# Contributing

We welcome your contributions to the project. Thank you!

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.


## What to contribute

This repository, `rubocop-github`, is part of a broader RuboCop ecosystem.

If the Cop you would like to propose is **generally applicable outside of GitHub**:

1. Propose the change upstream in the core open source project (e.g. [`rubocop`](https://github.com/rubocop/rubocop), or [`rubocop-rails`](https://github.com/rubocop/rubocop-rails)), where it will have maximal visibility and discussion/feedback.
1. Patch the change provisionally into GitHub's project(s), for immediate benefit; that can include this repository.
1. ...if the proposal is accepted, remove the patch and pull the updated upstream.
1. ...if the proposal is not accepted, we usually learn something about our proposal, and we then choose whether to maintain the patch ourselves, discard it, or identify a better open-source home for it.

If the Cop is **only applicable for GitHub**, then this is the right place to propose it.

## How to contribute a Pull Request

1. Fork and clone the repository
1. [Build it and make sure the tests pass](README.md#Testing) on your machine
1. Create a new branch: `git checkout -b my-branch-name`
1. Make your change, add tests, and make sure the tests still pass
1. Push to your fork and submit a Pull Request
1. Pat yourself on the back and wait for your pull request to be reviewed and merged.

## For Maintainers

### Updating Rubocop Dependencies

Rubocop regularly releases new versions with new cops. We want to keep up to date with the latest Rubocop releases, and keep these rules and styleguide in sync to reduce burden on consumers of this gem.

- Run `bundle update rubocop rubocop-performance rubocop-rails` to update the dependencies within this repository. Major updates will require updating the `.gemspec` file because of the pinned version constraints.
- Run `bundle exec rubocop`, and copy the output of newly introduced rules into `config/default_pending.yml` and `config/rails_pending.yml`. They should look like this:

  ```sh
  Lint/DuplicateMagicComment: # new in 1.37
    Enabled: true
  Style/OperatorMethodCall: # new in 1.37
    Enabled: true
  Style/RedundantStringEscape: # new in 1.37
    Enabled: true
  ```

- Run `bundle exec rubocop` again to ensure that it runs cleanly without any pending cops. Also run `bundle exec rake` to run the tests.
- Work through the pending cops, and copy them to `config/{default,rails}.yml` with an explicity `Enabled: true` or `Enabled: false` depending on your decision as to whether they should be part of our standard ruleset.

### Releasing a new version

1. Update `rubocop-github.gemspec` with the next version number
1. Update the `CHANGELOG` with changes and contributor
1. Run `bundle` to update gem version contained in the lockfile
1. Make a commit: `Release v{VERSION}`
1. Tag the commit : `git tag v{VERSION}`
1. Create the package: `gem build rubocop-github.gemspec`
1. Push to GitHub: `git push origin && git push origin --tags`
1. Push to Rubygems: `gem push rubocop-github-{VERSION}.gem`
1. Publish a new release on GitHub: https://github.com/github/rubocop-github/releases/new
