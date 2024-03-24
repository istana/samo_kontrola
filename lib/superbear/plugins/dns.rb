require "json_schemer"
require "dnsruby"

class Superbear::Plugins::Dns
  SCHEMA = {
    "$schema": "https://json-schema.org/draft/2020-12/schema",
    "$id": "superbear/plugins/dns",
    type: "object",
    additionalProperties: false,
    properties: {
      IN: {
        type: "object",
        additionalProperties: false,
        properties: {
          A: {
            type: "array",
            items: {
              type: "string",
            },
          },
          AAAA: {
            type: "array",
            items: {
              type: "string",
            },
          },
          MX: {
            type: "array",
            items: {
              type: "object",
              additionalProperties: false,
              properties: {
                preference: {
                  type: "number",
                },
                exchange: {
                  type: "string",
                },
              },
            },
          },
          NS: {
            type: "array",
            items: {
              type: "string",
            },
          },
          PTR: {
            type: "array",
            items: {
              type: "string",
            },
          },
          SOA: {
            type: "array",
            items: {
              type: "object",
              additionalProperties: false,
              properties: {
                mname: {
                  type: "string",
                },
                rname: {
                  type: "string",
                },
                serial: {
                  type: "number",
                },
                refresh: {
                  type: "number",
                },
                retry: {
                  type: "number",
                },
                expire: {
                  type: "number",
                },
                minimum_ttl: {
                  type: "number",
                },
              },
            },
          },
          TXT: {
            type: "array",
            items: {
              type: "string",
            },
          },
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

    @in = checklist_json["IN"]
    @host = checklist_json["host"]
    @type = checklist_json["type"]

    @logger = logger
  end

  def call
    resolver = Dnsruby::Resolver.new

    if @in["A"]
      response = resolver.query(@host, "A").answer.map { |a| a.address.to_s }

      if response.sort == @in["A"].sort
        @logger.write(
          host: @host,
          success: true,
          plugin: "DNS",
          attribute: "IN/A",
          message: "Expected #{@in['A']} matches received #{response}",
        )
      else
        @logger.write(
          host: @host,
          success: false,
          plugin: "DNS",
          attribute: "IN/A",
          message: "Expected #{@in['A']} does not match received #{response}",
        )
      end
    end

    if @in["AAAA"]
      response = resolver.query(@host, "AAAA").answer.map { |a| a.address.to_s }.map(&:downcase)

      if response.sort == @in["AAAA"].sort
        @logger.write(
          host: @host,
          success: true,
          plugin: "DNS",
          attribute: "IN/AAAA",
          message: "Expected #{@in['AAAA']} matches received #{response}",
        )
      else
        @logger.write(
          host: @host,
          success: false,
          plugin: "DNS",
          attribute: "IN/AAAA",
          message: "Expected #{@in['AAAA']} does not match received #{response}",
        )
      end
    end

    if @in["MX"]
      response = resolver.query(@host, "MX").answer.map do |item|
        { "preference" => item.preference, "exchange" => item.exchange.to_s }
      end

      if response.sort == @in["MX"].sort
        @logger.write(
          host: @host,
          success: true,
          plugin: "DNS",
          attribute: "IN/MX",
          message: "Expected #{@in['MX']} matches received #{response}",
        )
      else
        @logger.write(
          host: @host,
          success: false,
          plugin: "DNS",
          attribute: "IN/MX",
          message: "Expected #{@in['MX']} does not match received #{response}",
        )
      end
    end

    if @in["NS"]
      response = resolver.query(@host, "NS").answer.map { |ns| ns.nsdname.to_s }

      if response.sort == @in["NS"].sort
        @logger.write(
          host: @host,
          success: true,
          plugin: "DNS",
          attribute: "IN/NS",
          message: "Expected #{@in['NS']} matches received #{response}",
        )
      else
        @logger.write(
          host: @host,
          success: false,
          plugin: "DNS",
          attribute: "IN/NS",
          message: "Expected #{@in['NS']} does not match received #{response}",
        )
      end
    end

    if @in["PTR"]
      response = resolver.query(@host, "PTR").answer.map { |ptr| ptr.domainname.to_s }

      if response.sort == @in["PTR"].sort
        @logger.write(
          host: @host,
          success: true,
          plugin: "DNS",
          attribute: "IN/PTR",
          message: "Expected #{@in['PTR']} matches received #{response}",
        )
      else
        @logger.write(
          host: @host,
          success: false,
          plugin: "DNS",
          attribute: "IN/PTR",
          message: "Expected #{@in['PTR']} does not match received #{response}",
        )
      end
    end

    if @in["SOA"]
      response = resolver.query(@host, "SOA").answer.map do |soa|
        {
          "mname" => soa.mname.to_s,
          "rname" => soa.rname.to_s,
          "serial" => soa.serial,
          "refresh" => soa.refresh,
          "retry" => soa.retry,
          "expire" => soa.expire,
          "minimum_ttl" => soa.minimum,
        }
      end.first

      # TODO: array
      if response == @in["SOA"].first
        @logger.write(
          host: @host,
          success: true,
          plugin: "DNS",
          attribute: "IN/SOA",
          message: "Expected #{@in['SOA']} matches received #{response}",
        )
      else
        @logger.write(
          host: @host,
          success: false,
          plugin: "DNS",
          attribute: "IN/SOA",
          message: "Expected #{@in['SOA']} does not match received #{response}",
        )
      end
    end

    if @in["TXT"]
      response = resolver.query(@host, "TXT").answer.map(&:data)

      if response.sort == @in["TXT"].sort
        @logger.write(
          host: @host,
          success: true,
          plugin: "DNS",
          attribute: "IN/TXT",
          message: "Expected #{@in['TXT']} matches received #{response}",
        )
      else
        @logger.write(
          host: @host,
          success: false,
          plugin: "DNS",
          attribute: "IN/TXT",
          message: "Expected #{@in['TXT']} does not match received #{response}",
        )
      end
    end

    # if @status
    #   if @status.to_s == status
    #     @logger.write(
    #       host: @host,
    #       success: true,
    #       plugin: 'http',
    #       attribute: 'status',
    #       message: "Expected #{@status} matches received #{status}"
    #     )
    #   else
    #     @logger.write(
    #       host: @host,
    #       success: false,
    #       plugin: 'http',
    #       attribute: 'status',
    #       message: "Expected #{@status} does not match received #{status}"
    #     )
    #   end
    # end

    # if @body
    #   if body.include?(@body.to_s)
    #     @logger.write(
    #       host: @host,
    #       success: true,
    #       plugin: 'http',
    #       attribute: 'body',
    #       message: "Expected #{@body} is present in received body"
    #     )
    #   else
    #     @logger.write(
    #       host: @host,
    #       success: false,
    #       plugin: 'http',
    #       attribute: 'body',
    #       message: "Expected #{@body} isdoes not contain received #{body}"
    #     )
    #   end
    # end
  end
end
