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
          checklist: {
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
        required: ['filename', 'checklist'],
      }

      {
        errors: JSON::Validator.fully_validate(schema, data, strict: true)
      }
    end
  end

  class ParameterError < StandardError; end

  attr_reader :filename, :checklist

  def initialize(data)
    stringified_data = JSON.load(JSON.dump(data))
    validation_result = InputDataContract.call(stringified_data)
    raise ParameterError.new(validation_result[:errors].join(", ")) if validation_result[:errors].any?

    @filename = stringified_data['filename']
    @checklist = stringified_data['checklist']

    @checklist = @checklist.map do |item|
      Superbear::ServiceChecklist.new(item)
    end
  end
end
