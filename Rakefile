$LOAD_PATH.unshift File.expand_path('lib', __dir__)
require 'voxpupuli/release/version'

task default: :dummy

desc 'Dummy rake task'
task 'dummy' do
  puts 'this is a dummy rake task that just prints this line.'
end

begin
  require 'github_changelog_generator/task'
rescue LoadError
  # github_changelog_generator is an optional group
else
  GitHubChangelogGenerator::RakeTask.new :changelog do |config|
    version = Voxpupuli::Release::VERSION
    config.future_release = "v#{version}" if /^\d+\.\d+.\d+$/.match?(version)
    config.header = "# Changelog\n\nAll notable changes to this project will be documented in this file."
    config.exclude_labels = %w[duplicate question invalid wontfix wont-fix skip-changelog]
    config.user = 'voxpupuli'
    config.project = 'voxpupuli-release'
  end
end

begin
  require 'voxpupuli/rubocop/rake'
rescue LoadError
  # the voxpupuli-rubocop gem is optional
end
