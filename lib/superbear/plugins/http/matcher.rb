RSpec::Matchers.define :have_http_code do |expected_code|
  match do |host|
    @response = Typhoeus.get(
      url,
      headers: {
        'User-Agent' => 'Superbear - https://github.com/istana/superbear'
      }
    )

    expected_code.matches?(@response.code)
  end

  diffable
end

RSpec::Matchers.define :have_http_body do |expected_body|
  match do |host|
    @response = Typhoeus.get(
      url,
      headers: {
        'User-Agent' => 'Superbear - https://github.com/istana/superbear'
      }
    )

    expected_body.matches?(@response.body)
  end

  diffable
end

:have_http_body
:have_http_version
