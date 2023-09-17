require 'dry-validation'

class Superbear::ChecklistItem
  class InputDataContract < Dry::Validation::Contract
    #params do
    #  required(:data).value(:hash?, :unique_keys?)
    #end

    #configure do
    #  def unique_keys?(input)
    #    input
    #  end
    #end
  end

  def initialize(data)
    @data = data

  end
end
