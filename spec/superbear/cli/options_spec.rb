require "open3"

RSpec.describe "Superbear CLI" do
  let(:binpath) { File.expand_path("../../../bin/superbear", __dir__) }

  it "prints error message when no file argument" do
    stdout_str, _, status = Open3.capture3(binpath.to_s)

    expect(stdout_str).to eq("Specify at least one file definition\n")
    expect(status.exitstatus).to eq(1)
  end

  describe "help" do
    let(:helpstring) do
      <<~HEREDOC
        Usage: #{binpath} [files]
            -v, --[no-]verbose               use dot or doc formatter, output contains dots or detailed steps and failed checks
            -C, --check-configuration        check configuration and exit
            -l, --log FILE                   log to a file
                --version                    show version
            -h, --help                       show this message
      HEREDOC
    end

    it "shows help with -h" do
      stdout_str, _, status = Open3.capture3("#{binpath} -h")

      expect(stdout_str).to eq(helpstring)
      expect(status.exitstatus).to eq(1)
    end

    it "shows help with --help" do
      stdout_str, _, status = Open3.capture3("#{binpath} --help")

      expect(stdout_str).to eq(helpstring)
      expect(status.exitstatus).to eq(1)
    end
  end
end
