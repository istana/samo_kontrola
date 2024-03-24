require "json_schemer"
require "net/ssh"

class Superbear::Plugins::Ssh
  SCHEMA = {
    "$schema": "https://json-schema.org/draft/2020-12/schema",
    "$id": "superbear/plugins/ssh",
    type: "object",
    additionalProperties: false,
    properties: {
      keys: {
        type: "array",
        items: {
          type: "object",
          additionalProperties: false,
          properties: {
            algorithm: {
              type: "string",
            },
            fingerprint: {
              type: "string",
            },
          },
          required: %w[algorithm fingerprint],
        },
      },
      host: {
        type: "string",
      },
      type: {
        type: "string",
      },
    },
    required: %w[host type],
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

  attr_reader :body, :host, :status, :type

  def initialize(data:, logger:)
    checklist_json = JSON.parse(JSON.dump(data))
    validation_result = InputDataContract.call(checklist_json)

    if validation_result[:errors].any?
      errors = validation_result[:errors]
        .map { |error| "#{error['data']}: #{error['error']}" }.join(", ")

      raise ParameterError, errors
    end

    @keys = checklist_json["keys"]
    @host = checklist_json["host"]
    @type = checklist_json["type"]

    @logger = logger
  end

  def call
    transport = Net::SSH::Transport::Session.new(@host)
    # TODO: fix warnings, solution unknown
    ssh_keys = transport.host_keys.map do |key|
      {
        "ssh_signature_type" => key.ssh_signature_type,
        "fingerprint" => key.fingerprint,
      }
    end

    @keys.each do |key|
      server_key = ssh_keys.find { |ssh_key| ssh_key["ssh_signature_type"] == key["algorithm"] }

      if !server_key
        @logger.write(
          host: @host,
          success: false,
          plugin: "ssh",
          attribute: "algorithm",
          message: "Expected to find #{key['algorithm']} among server SSH keys",
        )

      else
        if key["fingerprint"] == server_key["fingerprint"]
          @logger.write(
            host: @host,
            success: true,
            plugin: "ssh",
            attribute: "fingerprint",
            message: "Expected #{key['fingerprint']} matches received #{server_key['fingerprint']}",
          )
        else
          @logger.write(
            host: @host,
            success: false,
            plugin: "ssh",
            attribute: "fingerprint",
            message: "Expected #{key['fingerprint']} does not match received #{server_key['fingerprint']}",
          )
        end
      end
    end
  end
end
