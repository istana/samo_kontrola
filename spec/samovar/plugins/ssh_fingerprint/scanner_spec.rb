RSpec.describe Samovar::Plugins::SshFingerprint::Scanner do
  it 'gets a fingerprint for a host' do
    allow(Net::SSH::Transport::Session).to receive(:new).and_return(double(
      host_keys: [
        double(
          ssh_signature_type: 'ecdsa-sha2-nistp256',
          fingerprint: 'f3:b0:0c:be:6b:ed:aa:f6:c7:91:cb:11:99:f1:48:2b',
        ),
        double(
          ssh_signature_type: 'ssh-rsa',
          fingerprint: 'cb:f0:a6:71:65:19:4c:db:f7:4d:26:b8:56:b0:bc:4c',
        ),
        double(
          ssh_signature_type: 'ssh-ed25519',
          fingerprint: '13:34:49:be:5e:83:70:15:8a:e0:7f:c4:48:76:3e:48',
        ),
      ]
    ))

    expect(Samovar::Plugins::SshFingerprint::Scanner.(host: 'example.com')).to match_array([
      {
        ssh_signature_type: 'ecdsa-sha2-nistp256',
        fingerprint: 'f3:b0:0c:be:6b:ed:aa:f6:c7:91:cb:11:99:f1:48:2b',
      },
      {
        ssh_signature_type: 'ssh-rsa',
        fingerprint: 'cb:f0:a6:71:65:19:4c:db:f7:4d:26:b8:56:b0:bc:4c',
      },
      {
        ssh_signature_type: 'ssh-ed25519',
        fingerprint: '13:34:49:be:5e:83:70:15:8a:e0:7f:c4:48:76:3e:48',
      },
    ])
  end
end
