require 'net/ssh'
require 'rspec/core'
require 'dry-validation'

class Superbear::Plugins::HaveSshFingerprint
  class InputDataContract < Dry::Validation::Contract
    params do
      required(:ssh_fingerprint).hash do
        optional(:not_match).array(:string)
        optional(:match).array(:hash) do
          required(:type).value(:string)
          required(:fingerprint).value(:string)
        end
      end
    end
  end

  module Matcher
    extend RSpec::Matchers::DSL

    matcher :have_ssh_fingerprints do |expected_fingerprints|
      match do |host|
        @actual = Superbear::Plugins::HaveSshFingerprint.get_fingerprints(host: host)
        match_array(expected_fingerprints).matches?(@actual)
      end

      match_when_negated do |host|
        @actual = Superbear::Plugins::HaveSshFingerprint.get_fingerprints(host: host).map{|key| key[:fingerprint]}
        @actual.none? {|fingerprint| expected_fingerprints.include?(fingerprint)}
      end

      diffable
    end
  end

  class << self
    def validate_input_data!(yaml_data)
      contract = YamlContract.new
      contract.call(yaml_data)
    end

    def load_to_rspec!(host, definitions)
      RSpec.define(host) do
        it 'checks SSH fingerprints for match' do
          expect(host).to have_ssh_fingerprints(definitions.dig(:ssh_fingerprint, :match))
        end

        it 'checks SSH fingerprints to not be present' do
          expect(host).not_to have_ssh_fingerprints(definitions.dig(:ssh_fingerprint, :exclude))
        end
      end
    end

    def get_fingerprints(host:)
      transport = Net::SSH::Transport::Session.new(host)
      transport.host_keys.map do |key|
        {
          ssh_signature_type: key.ssh_signature_type,
          fingerprint: key.fingerprint,
        }
      end
    end
  end
end
