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
