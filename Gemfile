source ENV['GEM_SOURCE'] || 'https://rubygems.org'

gemspec

group :release, optional: true do
  gem 'github_changelog_generator', '>= 1.16.1',  :require => false if RUBY_VERSION >= '2.5.0'
end
