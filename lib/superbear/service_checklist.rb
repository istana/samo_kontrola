require 'json_schemer'

class Superbear::ServiceChecklist
  SCHEMA = {
    "$schema": "https://json-schema.org/draft/2020-12/schema",
    "$id": "superbear/service_checklist",
    type: "object",
    additionalProperties: false,
    properties: {
      host: {
        type: "string",
        # TODO: ipv4, v6, reverse v4, reverse v6, domain, reverse domain
        #pattern: /\A\w+\.ya?ml\z/i,
      },
      checklist: {
        type: "array",
      },
    },
    required: ['host', 'checklist'],
  }.freeze

  class ParameterError < StandardError; end
  class InputDataContract
    def self.call(data)
      schemer = JSONSchemer.schema(SCHEMA, regexp_resolver: "ruby")

      {
        errors: schemer.validate(data).to_a
      }
    end
  end

  attr_reader :host, :checklist

  def initialize(data)
    checklist_json = JSON.load(JSON.dump(data))
    validation_result = InputDataContract.call(checklist_json)

    if validation_result[:errors].any?
      errors = validation_result[:errors]
        .map{|error| "#{error['data']}: #{error['error']}"}.join(", ")

      raise ParameterError.new(errors)
    end

    @host = checklist_json['host']
    @checklist = checklist_json['checklist']
  end
end
