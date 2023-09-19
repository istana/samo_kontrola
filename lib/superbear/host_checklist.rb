require 'dry-validation'
require 'dry-types'
require_relative './types'
require 'json-schema'


class Superbear::HostChecklist
  class InputDataContract
    def self.call(data)
      schema = {
        :"$id" => "superbear/host_checklist",
        type: :object,
        properties: {
          filename: {
            type: :string,
            pattern: /\A\w+\.ya?ml\z/i,
          },
          data: {
            type: :array,
            items: {
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
          }
        },
        required: ['filename', 'data'],
      }

      JSON::Validator.fully_validate(schema, data, strict: true)
    end
  end

  class ParameterError < StandardError; end

  attr_reader :filename, :items

  def initialize(**kwargs)
    stringified_data = JSON.load(JSON.dump(kwargs))
    errors = InputDataContract.call(stringified_data)
    raise ParameterError.new(errors.join(", ")) if errors.any?

    @filename = stringified_data['filename']
    @items = stringified_data['data']
  end
end
