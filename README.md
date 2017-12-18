# Voxpupuli Release Gem

This is a helper Gem for the Vox Pupuli release workflow. This Gem currently serves only to encapsulate common `rake` tasks related to releasing modules.

# Usage
Add the `voxpupuli-release` Gem to your `Gemfile`:

```
gem 'voxpupuli-release', git: 'https://github.com/voxpupuli/voxpupuli-release-gem'
```

Then, at the top of your `Rakefile`, add:

```ruby
require 'voxpupuli-release'
```

# Making a new release

## Preparations

First we prepare the release. Ensure you're on a clean branch. Also set ```CHANGELOG_GITHUB_TOKEN``` so you can generate the changelog without hitting rate limts.

```
bundle exec rake prepare_release[NEW_VERSION]
```

This will bump the version. You can either use `major`, `minor`, `patch` or specify a full version in the `X.Y.Z` format.

Next you commit this, push it to your remote and create a PR. The following code makes some assumptions about your layout:

```bash
VERSION="$(bundle exec rake module:version)"
git checkout -b release-$VERSION
git add metadata.json CHANGELOG.md
git commit -m "Release $VERSION"

# Push it to a remote that matches your username
git push $(whoami) HEAD -u

# Assumes you have hub installed
hub pull-request -m "Release $VERSION"
```

## Releasing

We'll assume that the preparation PR was acknowledged and merged.

```
bundle exec rake travis_release
```
