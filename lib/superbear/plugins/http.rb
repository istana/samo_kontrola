require 'json_schemer'

class Superbear::Plugins::Http
  SCHEMA = {
    "$schema": "https://json-schema.org/draft/2020-12/schema",
    "$id": "superbear/plugins/http",
    type: "object",
    additionalProperties: false,
    properties: {
      body: {
        type: "string",
      },
      host: {
        type: "string",
      },
      status: {
        type: "integer",
      },
      type: {
        type: "string",
      },
    },
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

  attr_reader :body, :host, :status, :type

  def initialize(data)
    checklist_json = JSON.load(JSON.dump(data))
    validation_result = InputDataContract.call(checklist_json)

    if validation_result[:errors].any?
      errors = validation_result[:errors]
        .map{|error| "#{error['data']}: #{error['error']}"}.join(", ")

      raise ParameterError.new(errors)
    end

    @body = checklist_json['body']
    @host = checklist_json['host']
    @status = checklist_json['status']
    @type = checklist_json['type']
  end

  def call
    puts 'http bla'
  end
end
