require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.test_files = FileList['test/**/*_test.rb']
end

task :default => :test

desc "Make a new build and publish it to RubyGems"
task :publish do
  build_name_and_version = "nin-#{Nin::VERSION}.gem"

  system "gem build nin.gemspec --silent --output #{build_name_and_version}"
  system "gem push #{build_name_and_version}"
end
