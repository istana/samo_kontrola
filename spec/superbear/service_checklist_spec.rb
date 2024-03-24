RSpec.describe Superbear::ServiceChecklist do
  describe "SCHEMA" do
    it "is valid JSON schema" do
      # TODO: ruby regex is not valid according to spec
      expect(JSONSchemer.validate_schema(described_class::SCHEMA).to_a).to eq([])
    end
  end

  describe described_class::InputDataContract do
    xit "requires host and TODO: checks if it is ipv4, v6, reverse v4, reverse v6, domain, reverse domain" do
      result = described_class.call({ host: "example.org", checklist: [] })
      expect(result).to eq({ errors: [] })
    end

    it "fails on superfluous attributes" do
      result = described_class.call({ host: "example.org", checklist: [], superfluous: "test" })
      expect(result[:errors]).to match([
        include({ "error" => "object property at `/superfluous` is a disallowed additional property" })
      ])
    end
  end

  it "raises on invalid parameters" do
    expect do
      described_class.new(host: "_example.org", checklist: {})
    end.to raise_error(described_class::ParameterError, "{}: value at `/checklist` is not an array")
  end

  it "provides host of checklist" do
    checklist = described_class.new(host: "example.org", checklist: [])
    expect(checklist.host).to eq("example.org")
  end

  it "provides checklist items" do
    data = {
      "host" => "example.com",
      "checklist" => [
        {
          "http" => {
            "status" => 302,
            "body" => "This domain is for use in illustrative examples in documents.",
          },
        }
      ],
    }

    service_checklist = described_class.new(data)
    expect(service_checklist.checklist).to eq(data["checklist"])
  end
end
