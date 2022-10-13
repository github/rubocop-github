# Contributing

## Releasing a new version

1. Update `rubocop-github.gemspec` with the next version number
2. Update the `CHANGELOG` with changes and contributor
3. Run `bundle` to update gem version contained in the lockfile
4. Make a commit: `Release v{VERSION}`
5. Tag the commit : `git tag v{VERSION}`
6. Create the package: `gem build rubocop-github.gemspec`
7.  Push to GitHub: `git push origin && git push origin --tags`
8. Push to Rubygems: `gem push rubocop-github-{VERSION}.gem`
9. Publish a new release on GitHub: https://github.com/github/rubocop-github/releases/new
