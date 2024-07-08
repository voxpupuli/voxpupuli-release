# frozen_string_literal: true

require 'puppet_blacksmith/rake_tasks'

class GCGConfig
  class << self
    attr_writer :user
  end

  def self.user
    @user || project.split(%r{[-/]}).first
  end

  class << self
    attr_writer :project
  end

  def self.project
    @project || metadata['name']
  end

  def self.metadata
    require 'puppet_blacksmith'
    @metadata ||= Blacksmith::Modulefile.new.metadata
  end

  class << self
    attr_writer :tag_pattern
  end

  def self.tag_pattern
    @tag_pattern || 'v%s'
  end

  def self.future_release
    if metadata['version'].match?(/^\d+\.\d+\.\d+$/)
      format(tag_pattern, metadata['version'])
    else
      # Not formatted like a release, might be a pre-release and the future
      # changes should better be under an "unreleased" section.
      nil
    end
  end
end

desc 'Release via GitHub Actions'
task :release do
  Blacksmith::RakeTask.new do |t|
    t.build = false # do not build the module nor push it to the Forge
    t.tag_sign = true # sign release with gpg
    t.tag_message_pattern = 'Version %s' # required tag message for gpg-signed tags
    # just do the tagging [:clean, :tag, :bump_commit]
  end

  m = Blacksmith::Modulefile.new
  v = m.version
  unless v.match?(/^\d+\.\d+\.\d+$/)
    raise "Refusing to release an RC or build-release (#{v}).\n" \
          'Please set a semver *release* version.'
  end

  # validate that the REFERENCE.md is up2date, if it exists
  Rake::Task['strings:validate:reference'].invoke if File.exist?('REFERENCE.md')
  Rake::Task[:check_changelog].invoke
  # do a "manual" module:release (clean, tag, bump, commit, push tags)
  Rake::Task['module:clean'].invoke

  # idempotently create tags
  g = Blacksmith::Git.new
  Rake::Task['module:tag'].invoke unless g.has_version_tag?(v)

  v_inc = m.increase_version(v)
  v_new = "#{v_inc}-rc0"
  ENV['BLACKSMITH_FULL_VERSION'] = v_new
  Rake::Task['module:bump:full'].invoke

  # push it out, and let GitHub Actions do the release:
  g.commit_modulefile!(v_new)
  g.push!
end

desc 'Deprecated: use the "release" task instead'
task 'travis_release' do
  warn "Deprecated: use the 'release' task instead"
  Rake::Task['release'].invoke
end

desc 'Check Changelog.'
task :check_changelog do
  v = Blacksmith::Modulefile.new.version
  # Acceptable release header formats:
  #
  # ## 2016-11-20 Release 4.0.2
  # ## [v4.0.3-rc0](https://github.com/voxpupuli/puppet-r10k/tree/v4.0.3-rc0) (2016-12-13)
  # ## [2.1.0](https://github.com/opus-codium/puppet-odoo/tree/2.1.0) (2021-12-02)
  if File.readlines('CHANGELOG.md').grep(/^(#.+[Rr]eleas.+#{Regexp.escape(v)}|## \[v?#{Regexp.escape(v)}\])/).empty?
    raise "Unable to find a CHANGELOG.md entry for the #{v} release."
  end
end

namespace :release do
  desc 'Prepare a release'
  task prepare: ['release:porcelain:changelog'] do
    v = Blacksmith::Modulefile.new.version
    Rake::Task['strings:generate:reference'].invoke if File.exist?('REFERENCE.md')
    puts <<~MESSAGE

      Please review these changes and commit them to a new branch:

          git checkout -b release-#{v}
          git commit --gpg-sign -am "Release #{v}"

      Then open a Pull-Request and wait for it to be reviewed and merged).
    MESSAGE
  end

  namespace :porcelain do
    require 'github_changelog_generator/task'
  rescue LoadError
    desc 'Dummy'
    task :changelog do
      puts 'Skipping CHANGELOG.md generation.  Ensure github_changelog_generator is present if you expected it to be generated.'
    end
  else
    task :changelog do
      # This is taken from lib/github_changelog_generator/task
      # The generator cannot be used because we want to lazyly evaluate
      # GCGConfig.user which might be overrider in the module Rakefile.
      options = GitHubChangelogGenerator::Parser.default_options
      options[:user] = GCGConfig.user
      options[:project] = GCGConfig.project
      options[:future_release] = GCGConfig.future_release
      options[:header] = <<~HEADER.chomp
        # Changelog

        All notable changes to this project will be documented in this file.
        Each new release typically also includes the latest modulesync defaults.
        These should not affect the functionality of the module.
      HEADER
      options[:exclude_labels] = %w[duplicate question invalid wontfix wont-fix modulesync skip-changelog]
      generator = GitHubChangelogGenerator::Generator.new(options)
      log = generator.compound_changelog
      output_filename = options[:output].to_s

      # Workaround for https://github.com/github-changelog-generator/github-changelog-generator/issues/715
      require 'rbconfig'
      unless RbConfig::CONFIG['host_os'].include?('windows')
        puts 'Fixing line endings...'
        log.gsub!("\r\n", "\n")
      end

      File.write(output_filename, log)
      puts "Generated log placed in #{File.absolute_path(output_filename)}"
    end
  end
end

# For backward compatibility
task :reference do
  warn <<-ERROR
  The "reference" task is deprecated.

  Prefer "release:prepare" which manage all pre-release steps, or directly run
  the "strings:generate:reference" task.
  ERROR
  exit(1)
end
