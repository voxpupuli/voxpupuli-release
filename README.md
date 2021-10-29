# Vox Pupuli Release Gem

[![License](https://img.shields.io/github/license/voxpupuli/voxpupuli-release.svg)](https://github.com/voxpupuli/voxpupuli-releasem/blob/master/LICENSE)
[![Release](https://github.com/voxpupuli/voxpupuli-release/actions/workflows/release.yml/badge.svg)](https://github.com/voxpupuli/voxpupuli-release/actions/workflows/release.yml)
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

To cut a new release of your module, ensure the `metadata.json` reflects the proper version. Also ensure that the `CHANGELOG.md` has a note about the release and that it actually is named Release or release, some old modules refer to it as Version, which won't work. Lastly check that no tag exists with that version number (format `v#.#.#`), and then run:

```plain
bundle exec rake release
```

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
