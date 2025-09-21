# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'bump/tasks'

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new(:lint)

desc 'Run the specs'
task default: :spec

Bump.tag_by_default = true
Rake::Task['bump:patch'].enhance(%w[lint spec])
Rake::Task['bump:minor'].enhance(%w[lint spec])
Rake::Task['bump:major'].enhance(%w[lint spec])
