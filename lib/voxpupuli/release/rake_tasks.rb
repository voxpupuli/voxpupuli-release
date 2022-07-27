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
        "Please set a semver *release* version." unless v =~ /^\d+\.\d+.\d+$/

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
  Rake::Task["release:porcelain:reference"].invoke if File.exist?('REFERENCE.md')
end

begin
  require 'github_changelog_generator/task'
  require 'puppet_blacksmith'
  GitHubChangelogGenerator::RakeTask.new "release:porcelain:changelog" do |config|
    metadata = Blacksmith::Modulefile.new
    config.future_release = "v#{metadata.version}" if metadata.version =~ /^\d+\.\d+.\d+$/
    config.header = "# Changelog\n\nAll notable changes to this project will be documented in this file.\nEach new release typically also includes the latest modulesync defaults.\nThese should not affect the functionality of the module."
    config.exclude_labels = %w{duplicate question invalid wontfix wont-fix modulesync skip-changelog}
    config.user = metadata.metadata['name'].split(%r{[-/]}).first
    config.user = 'voxpupuli' if config.user == "puppet"
    config.project = metadata.metadata['name']
  end

  # Workaround for https://github.com/github-changelog-generator/github-changelog-generator/issues/715
  require 'rbconfig'
  if RbConfig::CONFIG['host_os'] =~ /linux/
    task "release:porcelain:changelog" do
      puts 'Fixing line endings...'
      changelog_file = 'CHANGELOG.md'
      changelog_txt = File.read(changelog_file)
      new_contents = changelog_txt.gsub(%r{\r\n}, "\n")
      File.open(changelog_file, "w") {|file| file.puts new_contents }
    end
  end
rescue Blacksmith::Error
  # No metadata.json
end

desc "Generate REFERENCE.md"
task "release:porcelain:reference", [:debug, :backtrace] do |t, args|
  patterns = ''
  Rake::Task['strings:generate:reference'].invoke(patterns, args[:debug], args[:backtrace])
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
  the "release:porcelain:reference" task.
  ERROR
end
