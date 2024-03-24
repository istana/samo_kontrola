require "json_schemer"

class Superbear::HostChecklist
  SCHEMA = {
    "$schema": "https://json-schema.org/draft/2020-12/schema",
    "$id": "superbear/host_checklist",
    type: "object",
    additionalProperties: false,
    properties: {
      filename: {
        type: "string",
        pattern: '\A[\w/]+\.(ya?ml|YA?ML)\z',
      },
      checklist: {
        type: "array",
        items: {
          type: "object",
          additionalProperties: false,
          properties: {
            host: {
              type: "string",
            },
            checklist: {
              type: "array",
            },
          },
          required: %w[host checklist],
        },
      },
    },
    required: %w[filename checklist],
  }.freeze

  class ParameterError < StandardError; end

  class InputDataContract
    def self.call(data)
      schemer = JSONSchemer.schema(SCHEMA, regexp_resolver: "ruby")

      {
        errors: schemer.validate(data).to_a,
      }
    end
  end

  attr_reader :filename, :checklist

  def initialize(data)
    checklist_json = JSON.parse(JSON.dump(data))
    validation_result = InputDataContract.call(checklist_json)

    if validation_result[:errors].any?
      errors = validation_result[:errors]
        .map { |error| "#{error['data']}: #{error['error']}" }.join(", ")

      raise ParameterError, errors
    end

    @filename = checklist_json["filename"]
    @checklist = checklist_json["checklist"]
  end
end
