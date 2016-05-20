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

To cut a new release of your module, ensure the `metadata.json` reflects the proper version. Also ensure that the `CHANGELOG.md` has a note about the release and that it actually is named Release or release, some old modules refer to it as Version, which won't work. Lastly check that no tag exists with that version number (format `v#.#.#`), and then run:

```
bundle exec rake travis_release
```
