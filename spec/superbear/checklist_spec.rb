RSpec.describe Superbear::Checklist do
  describe Superbear::Checklist::InputDataContract do
    it 'requires filename and checks correct file extension' do
      result = described_class.new.call({ filename: 'my_server01.yml', data: [] })
      expect(result.errors).to be_empty

      result = described_class.new.call({ filename: 'MY_SERVER01.YML', data: [] })
      expect(result.errors).to be_empty

      result = described_class.new.call({ filename: 'my_server01.yaml', data: [] })
      expect(result.errors).to be_empty

      result = described_class.new.call({ filename: 'MY_SERVER01.YAML', data: [] })
      expect(result.errors).to be_empty
    end

    it 'fails on superfluous attributes' do
      result = described_class.new.call({ filename: 'aaa.yml', data: [], superfluous: 'test'})
      expect(result.errors.map(&:to_s)).to eq(['is not allowed'])
    end
  end

  it 'raises on invalid parameters' do
    expect do
      described_class.new(filename: 'my_server01.dll', data: [])
    end.to raise_error(Superbear::Checklist::ParameterError, 'filename: is in invalid format')
  end

  it 'saves filename of checklist' do
    checklist = described_class.new(filename: 'my_server01.yml', data: [])
    expect(checklist.filename).to eq('my_server01.yml')
  end

      require 'pry'
#      binding.pry
  it 'loads hosts and checks' do
    data = {
      filename: 'server01.yml',
      data: [
        {
          host: 'example.com',
          checklist: [
            {
              http: {
                status: 302,
                body: 'This domain is for use in illustrative examples in documents.'
              }
            }
          ]
        }
      ]
    }

    binding.pry
    checklist = described_class.new(**data)
    binding.pry
    #expect(checklist.)
  end
end
