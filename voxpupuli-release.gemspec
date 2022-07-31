# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'voxpupuli/release/version'

Gem::Specification.new do |s|
  s.name        = 'voxpupuli-release'
  s.version     = Voxpupuli::Release::VERSION
  s.authors     = ['Vox Pupuli']
  s.email       = ['voxpupuli@groups.io']
  s.homepage    = 'https://github.com/voxpupuli/voxpupuli-release'
  s.summary     = 'Helpers for deploying Vox Pupuli modules'
  s.description = s.summary
  s.licenses    = 'Apache-2.0'

  s.required_ruby_version = '>= 2.5', '< 4'

  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }

  # Runtime dependencies, but also probably dependencies of requiring projects
  s.add_runtime_dependency 'rake'
  s.add_runtime_dependency 'puppet-blacksmith', '>= 4.0.0'
  s.add_runtime_dependency 'puppet-strings', '>= 2.9.0'
end
