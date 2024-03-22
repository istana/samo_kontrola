RSpec.describe Superbear::ServiceChecklist do
  describe described_class::InputDataContract do
    it 'requires host and TODO: checks if it is ipv4, v6, reverse v4, reverse v6, domain, reverse domain' do
      result = described_class.call({ host: 'example.org', checklist: [] })
      expect(result).to eq({ errors: [] })
    end

    it 'fails on superfluous attributes' do
      result = described_class.call({ host: 'example.org', checklist: [], superfluous: 'test'})
      expect(result).to match(errors: match([%r{\AThe property '#/' contained undefined properties: 'superfluous' in schema .+\z}]))
    end
  end

  it 'raises on invalid parameters' do
    expect do
      described_class.new(host: '_example.org', checklist: [])
    end.to raise_error(described_class::ParameterError, %r{\AThe property '#/host' value "my_server01.dll" did not match the regex .+\z})
  end

  it 'saves host of checklist' do
    checklist = described_class.new(host: 'example.org', checklist: [])
    expect(checklist.host).to eq('example.org')
  end

  it 'loads hosts and checks' do
    service_checklist = double('service_checklist')
    allow(Superbear::ServiceChecklist).to receive(:new).and_return(service_checklist)

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

    checklist = described_class.new(data)
    expect(Superbear::ServiceChecklist).to have_received(:new).with(data.dig(0, 'checklist'))
    expect(checklist.checklist).to eq([service_checklist])
  end
end
