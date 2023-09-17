require 'pry'
RSpec.describe Superbear::ChecklistItem do
  describe Superbear::ChecklistItem::InputDataContract do
    it 'accepts host' do
      data = {
      	'myrtana.sk' => nil
      }

      result = described_class.new.call('data' => data)
      binding.pry
      expect(result.errors).to be_empty
      expect(result.to_h).to eq('data' => data)
    end
  end
end
