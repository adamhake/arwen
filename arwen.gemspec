# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)
require "arwen/version"

Gem::Specification.new do |spec|
  spec.name          = "arwen"
  spec.version       = Arwen::VERSION
  spec.authors       = ["Adam Hake"]
  spec.email         = ["adamhake@hey.com"]

  spec.summary       = "Parses a sitemap recursively using typheous"
  # rubocop:disable Metrics/LineLength
  spec.description   = "Arwen is a basic sitemap parser that auto detects sitemapindex and uses Typheous::Hydra for parallel requests"
  # rubocop:enable Metrics/LineLength
  spec.homepage      = "https://github.com/adamhake/arwen"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.5.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/adamhake/arwen"
  spec.metadata["changelog_uri"] = "https://github.com/adamhake/arwen/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "ox", "~> 2.14"
  spec.add_dependency "typhoeus", "~> 1.4"
end
