require "bundler/setup"
require "superbear"
require 'rspec/matchers/fail_matchers'

# do not truncate error message
RSpec::Support::ObjectFormatter.default_instance.max_formatted_output_length = nil

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include RSpec::Matchers::FailMatchers
end
