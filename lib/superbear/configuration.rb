require 'optparse'

class Superbear::Configuration
  attr_reader :files, :log_file, :only_check_configuration, :verbose

  def initialize(called_file:)
    @called_file = called_file

    begin
      cli_parser.parse!
    rescue OptionParser::MissingArgument
      puts parser.help
      exit(1)
    end

    if ARGV.size == 0
      puts 'Specify at least one file definition'
      exit(1)
    end

    files = ARGV
  end

  private

  def cli_parser
    OptionParser.new do |opts|
      opts.banner = "Usage: #{@called_file} [files]"
      opts.on("-v", "--[no-]verbose", "use dot or doc formatter, output contains dots or detailed steps and failed checks") do |value|
        @verbose = value
      end

      opts.on("-C", "--check-configuration", "check configuration and exit") do |v|
        @only_check_configuration = value
      end

      opts.on("-l", "--log FILE", "log to a file") do |v|
        @log_file = value
      end

      opts.on_tail("--version", "show version") do
        puts SuperBear::VERSION
        exit(1)
      end

      opts.on_tail("-h", "--help", "show this message") do
        puts opts
        exit(1)
      end
    end

  end
end
