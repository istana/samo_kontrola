RSpec.describe 'Superbear::Plugins::SshFingerprint RSpec matcher' do
  it 'checks if SSH fingerprints match' do
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

    expect {
      expect('myrtana.sk').to have_ssh_fingerprints([])
    }.to fail_with(%r{expected.*f3:b0:0c:be:6b:ed:aa:f6:c7:91:cb:11:99:f1:48:2b})

    expect {
      expect('myrtana.sk').to have_ssh_fingerprints([{
        ssh_signature_type: 'ecdsa-sha2-nistp256',
        fingerprint: 'f3:b0:0c:be:6b:ed:aa:f6:c7:91:cb:11:99:f1:48:2b',
      }])
    }.to fail_with(%r{expected.*f3:b0:0c:be:6b:ed:aa:f6:c7:91:cb:11:99:f1:48:2b})

    expect {
      expect('myrtana.sk').to have_ssh_fingerprints([{
        ssh_signature_type: 'ecdsa-sha2-nistp256',
        fingerprint: 'not present on server',
      }])
    }.to fail_with(%r{expected.*f3:b0:0c:be:6b:ed:aa:f6:c7:91:cb:11:99:f1:48:2b})

    expect('myrtana.sk').to have_ssh_fingerprints([
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

  describe 'no SSH keys on host' do
    it 'compares' do
      allow(Net::SSH::Transport::Session).to receive(:new).and_return(double(
        host_keys: []
      ))
      expect('myrtana.sk').to have_ssh_fingerprints([])

      expect {
        expect('myrtana.sk').to have_ssh_fingerprints([{
          ssh_signature_type: 'ecdsa-sha2-nistp256',
          fingerprint: 'f3:b0:0c:be:6b:ed:aa:f6:c7:91:cb:11:99:f1:48:2b',
        }])
      }.to fail_with(%r{expected.*f3:b0:0c:be:6b:ed:aa:f6:c7:91:cb:11:99:f1:48:2b})
    end
  end

  describe 'negated matcher' do
    it 'checks if fingerprints are not on host' do
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

      expect {
        expect('myrtana.sk').not_to have_ssh_fingerprints([{
          ssh_signature_type: 'ecdsa-sha2-nistp256',
          fingerprint: 'f3:b0:0c:be:6b:ed:aa:f6:c7:91:cb:11:99:f1:48:2b',
        }])
      }.to fail_with(%r{not expected.*f3:b0:0c:be:6b:ed:aa:f6:c7:91:cb:11:99:f1:48:2b})

      expect('myrtana.sk').not_to have_ssh_fingerprints([{
        ssh_signature_type: 'ecdsa-sha2-nistp256',
        fingerprint: 'not present on server',
      }])
    end
  end
end
