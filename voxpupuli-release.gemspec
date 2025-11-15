# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('lib', __dir__)
require 'voxpupuli/release/version'

Gem::Specification.new do |s|
  s.name        = 'voxpupuli-release'
  s.version     = Voxpupuli::Release::VERSION
  s.authors     = ['Vox Pupuli']
  s.email       = ['voxpupuli@groups.io']
  s.homepage    = 'https://github.com/voxpupuli/voxpupuli-release'
  s.summary     = 'Helpers for deploying Vox Pupuli modules'
  s.licenses    = 'Apache-2.0'

  s.required_ruby_version = '>= 3.2'

  s.files       = `git ls-files`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }

  # Runtime dependencies, but also probably dependencies of requiring projects
  s.add_dependency 'faraday-retry', '~> 2.1'
  s.add_dependency 'github_changelog_generator', '~> 1.16', '>= 1.16.4'
  s.add_dependency 'openvox-strings', '>= 5', '< 7'
  s.add_dependency 'puppet-blacksmith', '>= 8.0', '< 10'
  s.add_dependency 'rake', '~> 13.0', '>= 13.0.6'
  # openvox gem depends on syslog, but doesn't list it as explicit dependency
  # until Ruby 3.4, syslog was part of MRI ruby core
  # https://github.com/OpenVoxProject/puppet/issues/90
  s.add_dependency 'syslog', '~> 0.3.0'

  s.add_development_dependency 'voxpupuli-rubocop', '~> 5.0.0'
end
