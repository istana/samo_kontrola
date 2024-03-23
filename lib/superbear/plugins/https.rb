require 'json_schemer'
require 'net/http'

class Superbear::Plugins::Https
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
    required: ['host', 'type'],
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

  def initialize(data:, logger:)
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

    @logger = logger
  end

  def call
    request = Net::HTTP.new(@host, Net::HTTP.https_default_port)
    request.use_ssl = true
    request.start
    response = request.get("/")
    status = response.code
    body = response.body
    ip_address = request.ipaddr
    request.finish

    if @status
      if @status.to_s == status
        @logger.write(
          host: @host,
          success: true,
          plugin: 'https',
          attribute: 'status',
          message: "Expected #{@status} matches received #{status}"
        )
      else
        @logger.write(
          host: @host,
          success: false,
          plugin: 'https',
          attribute: 'status',
          message: "Expected #{@status} does not match received #{status}"
        )
      end
    end

    if @body
      if body.include?(@body.to_s)
        @logger.write(
          host: @host,
          success: true,
          plugin: 'https',
          attribute: 'body',
          message: "Expected #{@body} is present in received body"
        )
      else
        @logger.write(
          host: @host,
          success: false,
          plugin: 'https',
          attribute: 'body',
          message: "Expected #{@body} isdoes not contain received #{body}"
        )
      end
    end
  end
end
