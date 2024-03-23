class Superbear::Logger
  def write(host:, success:, plugin:, attribute:, message:)
    $stdout.puts("#{host}: #{plugin}/#{attribute} - #{message} | [#{success ? 'OK' : 'FAIL'}]")
  end
end
