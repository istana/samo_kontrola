require 'net/ssh'
require 'rspec'

class Superbear::Plugins::HaveSshFingerprint
  class << self
    def get_fingerprints(host)
      transport = Net::SSH::Transport::Session.new(host)
      transport.host_keys.map do |key|
        {
          ssh_signature_type: key.ssh_signature_type,
          fingerprint: key.fingerprint,
        }
      end
    end

    RSpec::Matchers.define :have_ssh_fingerprints do |expected_fingerprints|
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
end
