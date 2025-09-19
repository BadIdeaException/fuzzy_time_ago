# frozen_string_literal: true

require_relative 'lib/fuzzy_time_ago/version'

Gem::Specification.new do |spec|
  spec.name = 'fuzzy_time_ago'
  spec.version = FuzzyTimeAgo::VERSION
  spec.authors = ['BadIdeaException']

  spec.summary = 'Create fuzzy, human-readable time ago strings'
  spec.description = 'A Ruby gem that converts timestamps into fuzzy, human-friendly relative time strings ' \
                     "like 'less than a minute ago', 'about 2 months ago', etc."
  spec.homepage = 'https://github.com/BadIdeaException/fuzzy_time_ago'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.6.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/BadIdeaException/fuzzy_time_ago'

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z 2>/dev/null`.split("\x0").reject do |f|
      f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.require_paths = ['lib']

  # Development dependencies
  spec.add_development_dependency 'timecop', '~> 0.9.10'
end
