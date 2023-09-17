
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "superbear/version"

Gem::Specification.new do |spec|
  spec.name          = "superbear"
  spec.version       = Superbear::VERSION
  spec.authors       = ["Ivan Stana"]
  spec.email         = ["^_^@myrtana.sk"]

  spec.summary       = %q{RSpec matchers to check server configuration from the outside}
  spec.description   = %q{RSpec matchers to check server configuration from the outside}
  spec.homepage      = "https://github.com/istana/superbear"
  spec.license       = "GPL-3.0-or-later"

=begin
  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
    spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end
=end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  #spec.add_dependency "whois-parser", "~> 1.2"
  #spec.add_dependency "dnsruby", "~> 1.61"
  spec.add_dependency "net-ssh", "~> 6.0"
  spec.add_dependency "dry-validation"
  spec.add_dependency "json-schema"
  #spec.add_dependency "ed25519"
  #spec.add_dependency "bcrypt_pbkdf"
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "open3"
  spec.add_dependency "rspec", "~> 3.0"
end
