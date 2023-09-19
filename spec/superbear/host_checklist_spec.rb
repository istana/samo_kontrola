RSpec.describe Superbear::HostChecklist do
  describe Superbear::HostChecklist::InputDataContract do
    it 'requires filename and checks correct file extension' do
      result = described_class.call({ filename: 'my_server01.yml', data: [] })
      expect(result).to be_empty

      result = described_class.call({ filename: 'MY_SERVER01.YML', data: [] })
      expect(result).to be_empty

      result = described_class.call({ filename: 'my_server01.yaml', data: [] })
      expect(result).to be_empty

      result = described_class.call({ filename: 'MY_SERVER01.YAML', data: [] })
      expect(result).to be_empty
    end

    it 'fails on superfluous attributes' do
      result = described_class.call({ filename: 'aaa.yml', data: [], superfluous: 'test'})
      expect(result).to match([%r{\AThe property '#/' contained undefined properties: 'superfluous' in schema .+\z}])
    end
  end

  it 'raises on invalid parameters' do
    expect do
      described_class.new(filename: 'my_server01.dll', data: [])
    end.to raise_error(Superbear::HostChecklist::ParameterError, %r{\AThe property '#/filename' value "my_server01.dll" did not match the regex .+\z})
  end

  it 'saves filename of checklist' do
    checklist = described_class.new(filename: 'my_server01.yml', data: [])
    expect(checklist.filename).to eq('my_server01.yml')
  end

  it 'loads hosts and checks' do
    data = {
      'filename' => 'server01.yml',
      'data' => [
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

    checklist = described_class.new(**data)
    expect(checklist.items).to eq([
      {
        'host' => 'example.com',
        'checklist' => data.dig('data', 0, 'checklist'),
      }
    ])
  end
end
