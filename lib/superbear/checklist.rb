require 'dry-validation'
require 'dry-types'
require_relative './types'

class Superbear::Checklist
  module InputDataContractTypes
    include Dry::Types()

    YamlFilename = ::Dry::Schema::Types::Params::String.constrained(format: /\A\w+\.ya?ml\z/i)
  end

  class InputDataContract < Dry::Validation::Contract
    schema do
      #config.validate_keys = true

      #required(:filename).value(InputDataContractTypes::YamlFilename)
      required(:data).array(:hash) do
        required(:host).value(:string)
        require 'pry'
        binding.pry
        #required(:checklist).array(Superbear::Types::Nominal::Any)
        #required(:checklist).array(Superbear::Types::Params::Hash)
        required(:checklist).array(Superbear::Types::Nominal::Any)
      end
      #require 'pry'
      #binding.pry
    rescue StandardError => e
      require 'pry'
      binding.pry
    end
  end

  class InputDataContract2
    schema = {
      type: :object,
      properties: {
        filename: {
          type: :string,
        },
        data: {
          type: :object,
          properties: {
            host: {
              type: :string,
            },
            checklist: {
              type: :array,
            },
          },
          required: ['host', 'checklist'],
        }
      },
      required: ['filename', 'data'],
    }
  end

  class ParameterError < StandardError; end

  attr_reader :filename, :checks

  def initialize(**kwargs)
    validation_result = InputDataContract.new.call(kwargs)

    if validation_result.failure?
      errors = validation_result.errors.to_h.map{|(attribute, messages)| "#{attribute}: #{messages.join(',')}" }.join(' ')
      raise ParameterError.new(errors) 
    end

    @filename = validation_result[:filename]
    @checklist_items = validation_result[:data]
  end
end

        # require 'pry'
        # binding.pry
