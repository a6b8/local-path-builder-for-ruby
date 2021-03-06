# frozen_string_literal: true

require_relative "lib/local_path_builder/version"

Gem::Specification.new do |spec|
  spec.name          = "local_path_builder"
  spec.version       = LocalPathBuilder::VERSION
  spec.authors       = ["a6b8"]
  spec.email         = ["hello@13plu4.com"]

  spec.summary       = "Build all paths in one hash to local files and folders."
  spec.description   = "Usefull helper to build all paths in one hash to local files and folders."
  spec.homepage      = "https://github.com/a6b8/local-path-builder-for-ruby"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.4.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/a6b8/local-path-builder-for-ruby"
  spec.metadata["changelog_uri"] = "https://raw.githubusercontent.com/a6b8/local-path-builder-for-ruby/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "fileutils", "~> 1.5.0"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
