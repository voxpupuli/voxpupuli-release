
desc 'release new version through Travis-ci'
task "travis_release" do

  require 'puppet_blacksmith/rake_tasks'
  Blacksmith::RakeTask.new do |t|
    t.build = false # do not build the module nor push it to the Forge
    # just do the tagging [:clean, :tag, :bump_commit]
  end

  m = Blacksmith::Modulefile.new
  v = m.version
  raise "Refusing to release an RC or build-release (#{v}).\n" +
        "Please set a semver *release* version." unless v =~ /^\d+\.\d+.\d+$/

  Rake::Task[:check_changelog].invoke
  # do a "manual" module:release (clean, tag, bump, commit, push tags)
  Rake::Task["module:clean"].invoke

  # idempotently create tags
  g = Blacksmith::Git.new
  Rake::Task["module:tag"].invoke unless g.exec_git("tag -l v#{v}").strip == "v#{v}"

  v_inc = m.increase_version(v)
  v_new = "#{v_inc}-rc0"
  ENV['BLACKSMITH_FULL_VERSION'] = v_new
  Rake::Task["module:bump:full"].invoke

  # push it out, and let travis do the release:
  g.commit_modulefile!(v_new)
  g.push!
end

desc 'Check Changelog.'
task :check_changelog do
  v = Blacksmith::Modulefile.new.version
  if File.readlines('CHANGELOG.md').grep(/Releasing #{v}/).size == 0
    fail "Unable to find a CHANGELOG.md entry for the #{v} release."
  end
end
