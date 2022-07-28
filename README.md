# Vox Pupuli Release Gem

[![License](https://img.shields.io/github/license/voxpupuli/voxpupuli-release.svg)](https://github.com/voxpupuli/voxpupuli-release/blob/master/LICENSE)
[![Release](https://github.com/voxpupuli/voxpupuli-release/actions/workflows/release.yml/badge.svg)](https://github.com/voxpupuli/voxpupuli-release/actions/workflows/release.yml)
[![Test](https://github.com/voxpupuli/voxpupuli-release/actions/workflows/test.yml/badge.svg)](https://github.com/voxpupuli/voxpupuli-release/actions/workflows/test.yml)
[![RubyGem Version](https://img.shields.io/gem/v/voxpupuli-release.svg)](https://rubygems.org/gems/voxpupuli-release)
[![RubyGem Downloads](https://img.shields.io/gem/dt/voxpupuli-release.svg)](https://rubygems.org/gems/voxpupuli-release)

This is a helper Gem for the Vox Pupuli release workflow. This Gem currently serves only to encapsulate common `rake` tasks related to releasing modules.

## Usage

Add the `voxpupuli-release` Gem to your `Gemfile`:

```ruby
gem 'voxpupuli-release', git: 'https://github.com/voxpupuli/voxpupuli-release-gem'
```

Then, at the top of your `Rakefile`, add:

```ruby
require 'voxpupuli-release'
```

To cut a new release of your module, ensure the `metadata.json` reflects the expected new version of the module, that no tag exists with that version number (format `v#.#.#`), and then update the module `CHANGELOG.md` and `REFERENCE.md` by running:

```plain
bundle exec rake release:prepare
```

Commit these changes (likely in a new branch, open a Pull-Request and wait for it to be reviewed and merged).  When ready to ship the new release, ensure you are on the main branch, it is up-to-date, and run:

```plain
bundle exec rake release
```

This will perform some sanity checks, tag the current commit with the version number, and bump the version number to ensure no conflict will happen by mistake.

## License

This gem is licensed under the Apache-2 license.

## Release information

To make a new release, please do:

* update the version in `lib/voxpupuli/release/version.rb`
* Install gems with `bundle install --with release --path .vendor`
* generate the changelog with `bundle exec rake changelog`
* Check if the new version matches the closed issues/PRs in the changelog
* Create a PR with it
* After it got merged, push a tag. GitHub Actions will do the actual release to Rubygems and GitHub Packages
