#require 'json-schema'

class Superbear::ServiceChecklist
  class InputDataContract
    def self.call(data)
      schema = {
        :"$id" => "superbear/service_checklist",
        type: :object,
        properties: {
          host: {
            type: :string,
            # TODO: ipv4, v6, reverse v4, reverse v6, domain, reverse domain
            #pattern: /\A\w+\.ya?ml\z/i,
          },
          checklist: {
            type: :array,
          },
        },
        required: ['host', 'checklist'],
      }

      {
        errors: JSON::Validator.fully_validate(schema, data, strict: true)
      }
    end
  end

  class ParameterError < StandardError; end

  attr_reader :host, :checklist

  def initialize(*checklist, **kwargs)
    checklist_json = JSON.load(JSON.dump(kwargs))

    validation_result = InputDataContract.call(checklist_json)

    binding.pry
    raise ParameterError.new(validation_result[:errors].join(", ")) if validation_result[:errors].any?

    @host = stringified_data['host']
    @checklist = stringified_data['checklist']

    @checklist = @checklist.map do |check|
      plugin = check.keys.first

      defined?(plugin)
      plugin.constantize::InputDataContract.call(check[check.keys.first])
      
      Superbear::ServiceChecklist.new(item)
    end
  end
end
