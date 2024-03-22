RSpec.describe Superbear::HostChecklist do
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
      expect(result).to match(errors: match([%r{\AThe property '#/' contained undefined properties: 'superfluous' in schema .+\z}]))
    end
  end

  it 'raises on invalid parameters' do
    expect do
      described_class.new(filename: 'my_server01.dll', checklist: [])
    end.to raise_error(described_class::ParameterError, %r{\AThe property '#/filename' value "my_server01.dll" did not match the regex .+\z})
  end

  it 'saves filename of checklist' do
    checklist = described_class.new(filename: 'my_server01.yml', checklist: [])
    expect(checklist.filename).to eq('my_server01.yml')
  end

  it 'loads hosts and checks' do
    service_checklist = double('service_checklist')
    allow(Superbear::ServiceChecklist).to receive(:new).and_return(service_checklist)

    data = {
      'filename' => 'server01.yml',
      'checklist' => [
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
    }

    checklist = described_class.new(data)
    expect(Superbear::ServiceChecklist).to have_received(:new).with(data.dig('checklist', 0))
    expect(checklist.checklist).to eq([service_checklist])
  end
end
