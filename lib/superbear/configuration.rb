require 'optparse'

class Superbear::Configuration
  attr_reader :executable_name, :files #, :log_file, :only_check_configuration, :verbose

  def initialize(executable_name:)
    @executable_name = executable_name
    parser = cli_parser

    begin
      parser.parse!
    rescue OptionParser::MissingArgument
      puts parser.help
      exit(1)
    end

    if ARGV.size == 0
      puts parser.help
      exit(1)
    end

    @files = ARGV
  end

  private

  def cli_parser
    OptionParser.new do |opts|
      opts.banner = "Usage: #{executable_name} file [files]"
#      opts.on("-v", "--[no-]verbose", "use dot or doc formatter, output contains dots or detailed steps and failed checks") do |value|
#        @verbose = value
#      end

#      opts.on("-C", "--check-configuration", "check configuration and exit") do |v|
#        @only_check_configuration = value
#      end

#      opts.on("-l", "--log FILE", "log to a file") do |v|
#        @log_file = value
#      end

      opts.on_tail("--version", "show version") do
        puts Superbear::VERSION
        exit(1)
      end

      opts.on_tail("-h", "--help", "show this message") do
        puts opts
        exit(1)
      end
    end

  end
end
