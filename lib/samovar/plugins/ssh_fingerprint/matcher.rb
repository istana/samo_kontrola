RSpec::Matchers.define :have_ssh_fingerprints do |expected_fingerprints|
  match do |host|
    @actual = Samovar::Plugins::SshFingerprint::Scanner.(host: host)
    match_array(expected_fingerprints).matches?(@actual)
  end

  failure_message do |host|
    actual_list = actual.map{|fingerprint| "#{fingerprint[:ssh_signature_type]}/#{fingerprint[:fingerprint]}"}
    expected_list = expected_fingerprints.map{|fingerprint| "#{fingerprint[:ssh_signature_type]}/#{fingerprint[:fingerprint]}"}
    "expected #{actual_list.join(',')} to match #{expected_list.join(',')}"
  end

  match_when_negated do |host|
    @actual = Samovar::Plugins::SshFingerprint::Scanner.(host: host)
    @actual.none? {|fingerprint| expected_fingerprints.include?(fingerprint)}
  end

  failure_message_when_negated do |host|
    actual_list = actual.map{|fingerprint| "#{fingerprint[:ssh_signature_type]}/#{fingerprint[:fingerprint]}"}
    expected_list = expected_fingerprints.map{|fingerprint| "#{fingerprint[:ssh_signature_type]}/#{fingerprint[:fingerprint]}"}
    "not expected #{expected_list.join(',')} be present in #{actual_list.join(',')}"
  end

  diffable
end
