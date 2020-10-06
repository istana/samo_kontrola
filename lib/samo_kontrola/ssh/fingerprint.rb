=begin
       :kex=>
        ["curve25519-sha256",
         "curve25519-sha256@libssh.org",
         "ecdh-sha2-nistp256",
         "ecdh-sha2-nistp384",
         "ecdh-sha2-nistp521",
         "diffie-hellman-group-exchange-sha256",
         "diffie-hellman-group16-sha512",
         "diffie-hellman-group18-sha512",
         "diffie-hellman-group14-sha256",
         "diffie-hellman-group14-sha1"],
       :host_key=>
        ["rsa-sha2-512",
         "rsa-sha2-256",
         "ssh-rsa",
         "ecdsa-sha2-nistp256",
         "ssh-ed25519"],
       :encryption_client=>
        ["chacha20-poly1305@openssh.com",
         "aes128-ctr",
         "aes192-ctr",
         "aes256-ctr",
         "aes128-gcm@openssh.com",
         "aes256-gcm@openssh.com"],
       :encryption_server=>
        ["chacha20-poly1305@openssh.com",
         "aes128-ctr",
         "aes192-ctr",
         "aes256-ctr",
         "aes128-gcm@openssh.com",
         "aes256-gcm@openssh.com"],
       :hmac_client=>
        ["umac-64-etm@openssh.com",
         "umac-128-etm@openssh.com",
         "hmac-sha2-256-etm@openssh.com",
         "hmac-sha2-512-etm@openssh.com",
         "hmac-sha1-etm@openssh.com",
         "umac-64@openssh.com",
         "umac-128@openssh.com",
         "hmac-sha2-256",
         "hmac-sha2-512",
         "hmac-sha1"],
       :hmac_server=>
        ["umac-64-etm@openssh.com",
         "umac-128-etm@openssh.com",
         "hmac-sha2-256-etm@openssh.com",
         "hmac-sha2-512-etm@openssh.com",
         "hmac-sha1-etm@openssh.com",
         "umac-64@openssh.com",
         "umac-128@openssh.com",
         "hmac-sha2-256",
         "hmac-sha2-512",
         "hmac-sha1"],
=end

require 'net/ssh'

module SamoKontrola
  module Ssh
    module Fingerprint
      def self.call(host:)
        transport = Net::SSH::Transport::Session.new('myrtana.sk')
        transport.host_keys.map(&:fingerprint)
      end
    end
  end
end
