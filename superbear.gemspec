lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "superbear/version"

Gem::Specification.new do |spec|
  spec.required_ruby_version = ">= 3.3.0"
  spec.name          = "superbear"
  spec.version       = Superbear::VERSION
  spec.authors       = ["Ivan Stana"]
  spec.email         = ["^_^@myrtana.sk"]

  spec.summary       = "Program to validate configuration of network services"
  spec.description   = "Program to validate configuration of network services - HTTP(s), DNS, SSH"
  spec.homepage      = "https://github.com/istana/superbear"
  spec.license       = "GPL-3.0-or-later"

  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
    spec.metadata["rubygems_mfa_required"] = "true"

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/istana/superbear"
    spec.metadata["changelog_uri"] = "https://github.com/istana/superbear/blob/master/CHANGELOG.md"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "dnsruby"
  spec.add_dependency "json_schemer"
  spec.add_dependency "net-ssh"

  # spec.add_dependency "whois-parser", "~> 1.2"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "open3"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "rubocop-packaging"
  spec.add_development_dependency "rubocop-performance"
  spec.add_development_dependency "rubocop-rake"
  spec.add_development_dependency "rubocop-rspec"
end
