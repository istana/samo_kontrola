RSpec.describe Superbear::Plugins::HaveSshFingerprint do
  describe Superbear::Plugins::HaveSshFingerprint::YamlContract do
    it 'accepts fingerprints to match and not match' do
      data = {
        ssh_fingerprint: {
          match: [
            {
              type: 'ecdsa-sha2-nistp256',
              fingerprint: 'foo',
            },
            {
              type: 'ssh-ed25519',
              fingerprint: 'bar',
            }
          ],
          not_match: [
            'fingerprint1',
            'fingerprint2',
          ],
        }
      }

      result = described_class.new.call(data)
      expect(result.errors).to be_empty
      expect(result.to_h).to eq(data)
    end

    it 'accepts empty section' do
      data = {
        ssh_fingerprint: {
        }
      }

      expect(described_class.new.call(data).errors).to be_empty
    end

    it 'rejects empty data' do
      data = {
      }

      expect(described_class.new.call(data).errors).not_to be_empty
    end

    it 'requires type' do
      data = {
        ssh_fingerprint: {
          match: [
            {
              fingerprint: 'foo',
            },
          ],
        }
      }

      result = described_class.new.call(data)
      expect(described_class.new.call(data).errors).not_to be_empty
    end

    it 'requires fingerprint' do
      data = {
        ssh_fingerprint: {
          match: [
            {
              fingerprint: 'foo',
            },
          ],
        }
      }

      result = described_class.new.call(data)
      expect(described_class.new.call(data).errors).not_to be_empty
    end
  end

  describe '.get_fingerprints' do
    it 'returns keys containing type and fingerprint' do
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

      expect(described_class.get_fingerprints(host: 'example.com')).to match_array([
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

  describe 'positive have_ssh_fingerprints' do
    before do
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
    end

    it 'fails with diff for no expected' do
      expect {
        expect('myrtana.sk').to have_ssh_fingerprints([])
      }.to fail_with(/\Aexpected.*to have ssh fingerprints.*-\[\].*\+\[{:fingerprint=>"f3:b0:0c:be:6b:ed:aa:f6:c7:91:cb:11:99:f1:48:2b",.*\z/m)
    end

    it 'fails with diff for partial match' do
      expect {
        expect('myrtana.sk').to have_ssh_fingerprints([{
          ssh_signature_type: 'ecdsa-sha2-nistp256',
          fingerprint: 'f3:b0:0c:be:6b:ed:aa:f6:c7:91:cb:11:99:f1:48:2b',
        }])
      }.to fail_with(/\Aexpected.*to have ssh fingerprints.*-  :ssh_signature_type=>"ecdsa-sha2-nistp256"}\]\
.*\+ {:fingerprint=>"cb:f0:a6:71:65:19:4c:db:f7:4d:26:b8:56:b0:bc:4c",.*\z/m)
    end

    it 'passes full match' do
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
  end

  describe 'negative have_ssh_fingerprints' do
    before do
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
    end

    it 'fails when fingerprint is present on server' do
      expect {
        expect('myrtana.sk').not_to have_ssh_fingerprints([
          'f3:b0:0c:be:6b:ed:aa:f6:c7:91:cb:11:99:f1:48:2b',
        ])
      }.to fail_with(/\A.*expected \["f3:b0:0c:be:6b:ed:aa:f6:c7:91:cb:11:99:f1:48:2b", "cb:f0:a6:71:65:19:4c:db:f7:4d:26:b8:56:b0:bc:4c", \
"13:34:49:be:5e:83:70:15:8a:e0:7f:c4:48:76:3e:48"\] not to have ssh fingerprints "f3:b0:0c:be:6b:ed:aa:f6:c7:91:cb:11:99:f1:48:2b"\z/m)
    end
  end
end
