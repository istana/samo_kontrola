require "bundler/setup"
basedir = File.dirname(__FILE__)
Dir[File.join(basedir, "superbear", "*.rb")].each { |f| require f }
Dir[File.join(basedir, "superbear", "**", "*.rb")].each { |f| require f }

module Superbear
end
