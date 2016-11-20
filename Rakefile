require 'bundler/gem_tasks'
require 'rake/testtask'

if RUBY_ENGINE == 'jruby'
  require 'rake/javaextensiontask'

  Rake::JavaExtensionTask.new('did_you_mean') do |ext|
    ext.name    = "binding_capturer"
    ext.lib_dir = "lib/did_you_mean"
  end
end

Rake::TestTask.new do |task|
  task.libs << "test"

  task.test_files = Dir['test/**/*_test.rb'].reject do |path|
    /(verbose_formatter|experimental)/ =~ path
  end

  task.verbose = true
  task.warning = true
  task.ruby_opts << '--debug' if RUBY_ENGINE == 'jruby'
end

Rake::TestTask.new("test:verbose_formatter") do |task|
  task.libs << "test"
  task.pattern = 'test/verbose_formatter_test.rb'
  task.verbose = true
  task.warning = true
  task.ruby_opts << '--debug' if RUBY_ENGINE == 'jruby'
  task.ruby_opts << "-rdid_you_mean/verbose_formatter"
end

Rake::TestTask.new("test:experimental") do |task|
  task.libs << "test"
  task.pattern = 'test/experimental/**/*_test.rb'
  task.verbose = true
  task.warning = true
  task.ruby_opts << '--debug' if RUBY_ENGINE == 'jruby'
  task.ruby_opts << "-rdid_you_mean/experimental"
end

task default: %i(test test:verbose_formatter test:experimental)

namespace :test do
  namespace :accuracy do
    desc "Download Wiktionary's Simple English data and save it as a dictionary"
    task :prepare do
      sh 'ruby evaluation/dictionary_generator.rb'
    end
  end

  desc "Calculate accuracy of the gems' spell checker"
  task :accuracy do
    if !File.exist?("evaluation/dictionary.yml")
      puts 'Generating dictionary for evaluation:'
      Rake::Task["test:accuracy:prepare"].execute
      puts "\n"
    end

    sh 'bundle exec ruby evaluation/calculator.rb'
  end
end

namespace :benchmark do
  desc "Measure memory usage by the did_you_mean gem"
  task :memory do
    sh 'bundle exec ruby benchmark/memory_usage.rb'
  end
end
