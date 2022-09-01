require 'puppet_blacksmith/rake_tasks'

desc 'Release via GitHub Actions'
task :release do
  Blacksmith::RakeTask.new do |t|
    t.build = false # do not build the module nor push it to the Forge
    t.tag_sign = true # sign release with gpg
    t.tag_message_pattern = "Version %s" # required tag message for gpg-signed tags
    # just do the tagging [:clean, :tag, :bump_commit]
  end

  m = Blacksmith::Modulefile.new
  v = m.version
  raise "Refusing to release an RC or build-release (#{v}).\n" +
        "Please set a semver *release* version." unless v.match?(/^\d+\.\d+.\d+$/)

  # validate that the REFERENCE.md is up2date, if it exists
  Rake::Task['strings:validate:reference'].invoke if File.exist?('REFERENCE.md')
  Rake::Task[:check_changelog].invoke
  # do a "manual" module:release (clean, tag, bump, commit, push tags)
  Rake::Task["module:clean"].invoke

  # idempotently create tags
  g = Blacksmith::Git.new
  Rake::Task["module:tag"].invoke unless g.has_version_tag?(v)

  v_inc = m.increase_version(v)
  v_new = "#{v_inc}-rc0"
  ENV['BLACKSMITH_FULL_VERSION'] = v_new
  Rake::Task["module:bump:full"].invoke

  # push it out, and let GitHub Actions do the release:
  g.commit_modulefile!(v_new)
  g.push!
end

desc 'Deprecated: use the "release" task instead'
task "travis_release" do
  STDERR.puts "Deprecated: use the 'release' task instead"
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
  if File.readlines('CHANGELOG.md').grep( /^(#.+[Rr]eleas.+#{Regexp.escape(v)}|## \[v?#{Regexp.escape(v)}\])/ ).empty?
    fail "Unable to find a CHANGELOG.md entry for the #{v} release."
  end
end

desc "Prepare a release"
task "release:prepare" do
  Rake::Task["release:porcelain:changelog"].invoke
  Rake::Task["strings:generate:reference"].invoke if File.exist?('REFERENCE.md')
end

begin
  require 'github_changelog_generator/task'
  require 'puppet_blacksmith'
rescue LoadError
  desc "Dummy"
  task "release:porcelain:changelog" do
    puts "Skipping CHANGELOG.md generation.  Ensure github_changelog_generator is present if you expected it to be generated."
  end
else
  class GCGConfig
    def self.user=(user)
      @user = user
    end

    def self.user
      @user || metadata['name'].split(%r{[-/]}).first
    end

    def self.metadata
      @metadata ||= Blacksmith::Modulefile.new.metadata
    end
  end

  task "release:porcelain:changelog" do
    # This is taken from lib/github_changelog_generator/task
    # The generator cannot be used because we want to lazyly evaluate
    # GCGConfig.user which might be overrider in the module Rakefile.
    options = GitHubChangelogGenerator::Parser.default_options
    options[:user] = GCGConfig.user
    options[:project] = GCGConfig.metadata['name']
    options[:future_release] = "v#{GCGConfig.metadata['version']}" if GCGConfig.metadata['version'].match?(/^\d+\.\d+.\d+$/)
    options[:header] = <<~HEADER.chomp
      # Changelog

      All notable changes to this project will be documented in this file.
      Each new release typically also includes the latest modulesync defaults.
      These should not affect the functionality of the module.
    HEADER
    options[:exclude_labels] = %w{duplicate question invalid wontfix wont-fix modulesync skip-changelog}
    generator = GitHubChangelogGenerator::Generator.new(options)
    log = generator.compound_changelog
    output_filename = options[:output].to_s
    File.write(output_filename, log)

    # Workaround for https://github.com/github-changelog-generator/github-changelog-generator/issues/715
    require 'rbconfig'
    if RbConfig::CONFIG['host_os'].match?(/linux/)
      puts 'Fixing line endings...'
      changelog_file = 'CHANGELOG.md'
      changelog_txt = File.read(changelog_file)
      new_contents = changelog_txt.gsub(%r{\r\n}, "\n")
      File.write(changelog_file, new_contents)
    end
    puts "Generated log placed in #{File.absolute_path(output_filename)}"
  end
end

# For backward compatibility
task :changelog do
  fail <<-ERROR
  The "changelog" task is deprecated.

  Prefer "release:prepare" which manage all pre-release steps, or directly run
  the "release:porcelain:changelog" task.
  ERROR
end

# For backward compatibility
task :reference do
  fail <<-ERROR
  The "reference" task is deprecated.

  Prefer "release:prepare" which manage all pre-release steps, or directly run
  the "strings:generate:reference" task.
  ERROR
end
