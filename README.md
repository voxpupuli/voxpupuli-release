# Voxpupuli Gem
This is a helper Gem for the Vox Pupuli release workflow. This Gem currently serves only to encapsulate common `rake` tasks related to releasing modules.

# Usage
Add the `voxpupuli` Gem to your `Gemfile`:

```
gem 'voxpupuli', git: 'https://github.com/voxpupuli/voxpupuli-gem'
```

Then, at the top of your `Rakefile`, add:

```ruby
require 'voxpupuli'
```
