require 'net/ssh'

module Superbear
  module Plugins
    module SshFingerprint
      module Scanner
        def self.call(host)
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
  end
end
