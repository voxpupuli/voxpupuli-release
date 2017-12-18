require 'github_changelog_generator/task'

desc 'Prepare a new release'
task :prepare_release, [:version] do |t, args|
  unless args[:version]
    puts 'you need to provide a version like: rake prepare_release[1.0.0]'
    exit
  end

  version = args[:version]
  if ['major', 'minor', 'patch'].include?(version)
    bump_task = "module:bump:#{version}"
  elsif /^\d+\.\d+\.\d+$/.match(version)
    bump_task = 'module:bump:full'
    ENV['BLACKSMITH_FULL_VERSION'] = version
  else
    puts 'Version needs to be major, minor, patch or in the X.X.X format'
    exit
  end

  Rake::Task[bump_task].invoke
  Rake::Task['changelog'].invoke
end

desc 'release new version through Travis-ci'
task "travis_release" => [:check_version, :check_changelog, 'module:clean'] do

  require 'puppet_blacksmith/rake_tasks'
  Blacksmith::RakeTask.new do |t|
    t.tag_message_pattern = "Version %s" # Use annotated commits
  end

  # idempotently create tags
  m = Blacksmith::Modulefile.new
  g = Blacksmith::Git.new
  Rake::Task["module:tag"].invoke unless g.has_version_tag?(m.version)

  # Bump to the next version as rc0
  v_new = "#{m.increase_version(m.version)}-rc0"
  ENV['BLACKSMITH_FULL_VERSION'] = v_new
  Rake::Task["module:bump_commit:full"].invoke

  # push it out, and let travis do the release:
  g.push!
end

desc 'Check if the version is a semver release version'
task :check_version do
  m = Blacksmith::Modulefile.new
  v = m.version
  fail "Refusing to release an RC or build-release (#{v}).\n" +
       "Please set a semver *release* version." unless v =~ /^\d+\.\d+.\d+$/
end

desc 'Check Changelog.'
task :check_changelog do
  v = Blacksmith::Modulefile.new.version
  # Acceptable release header formats:
  #
  # ## 2016-11-20 Release 4.0.2
  # ## [v4.0.3-rc0](https://github.com/voxpupuli/puppet-r10k/tree/v4.0.3-rc0) (2016-12-13)
  if File.readlines('CHANGELOG.md').grep( /^(#.+[Rr]eleas.+#{Regexp.escape(v)}|## \[v#{Regexp.escape(v)}\])/ ).size == 0
    fail "Unable to find a CHANGELOG.md entry for the #{v} release."
  end
end

GitHubChangelogGenerator::RakeTask.new :changelog do |config|
  modulefile = Blacksmith::Modulefile.new
  config.user = 'voxpupuli'
  config.project = modulefile.name
  config.future_release = "v#{modulefile.version}" if modulefile.version =~ /^\d+\.\d+.\d+$/
  config.header = "# Changelog\n\nAll notable changes to this project will be documented in this file.\nEach new release typically also includes the latest modulesync defaults.\nThese should not affect the functionality of the module."
  config.exclude_labels = %w{duplicate question invalid wontfix wont-fix modulesync skip-changelog}
end
