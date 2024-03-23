RSpec.describe Superbear::HostChecklist do
  describe 'SCHEMA' do
    it 'is valid JSON schema' do
      # TODO: ruby regex is not valid according to spec
      expect(JSONSchemer.validate_schema(described_class::SCHEMA).to_a).to match([
        include({ "error" => "value at `/properties/filename/pattern` does not match format: regex" })
      ])
    end
  end

  describe described_class::InputDataContract do
    it 'requires filename and checks correct file extension' do
      result = described_class.call({ filename: 'my_server01.yml', checklist: [] })
      expect(result).to eq({ errors: [] })

      result = described_class.call({ filename: 'MY_SERVER01.YML', checklist: [] })
      expect(result).to eq({ errors: [] })

      result = described_class.call({ filename: 'my_server01.yaml', checklist: [] })
      expect(result).to eq({ errors: [] })

      result = described_class.call({ filename: 'MY_SERVER01.YAML', checklist: [] })
      expect(result).to eq({ errors: [] })
    end

    it 'fails on superfluous attributes' do
      result = described_class.call({ filename: 'aaa.yml', checklist: [], superfluous: 'test'})
      expect(result[:errors]).to match([
        include({ "error"=>"object property at `/superfluous` is a disallowed additional property" })
      ])
    end
  end

  it 'raises on invalid parameters' do
    expect do
      described_class.new(filename: 'my_server01.dll', checklist: [])
    end.to raise_error(described_class::ParameterError, 'my_server01.dll: string at `/filename` does not match pattern: \A\w+\.(ya?ml|YA?ML)\z')
  end

  it 'provides filename of checklist' do
    checklist = described_class.new(filename: 'my_server01.yml', checklist: [])
    expect(checklist.filename).to eq('my_server01.yml')
  end

  it 'provides checklist items' do
    data = [
      {
        'host' => 'example.com',
        'checklist' => [
          {
            'http' => {
              'status' => 302,
              'body' => 'This domain is for use in illustrative examples in documents.'
            }
          }
        ]
      }
    ]

    host_checklist = described_class.new(
      filename: 'my_server01.yml',
      checklist: data)
    expect(host_checklist.checklist).to eq(data)
  end
end
