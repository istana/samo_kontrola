# superbear

Features: (development in progress)

- open ports (ip address, hostname), scan if weird ports are NOT open
- ping
- ssh
  - ssh fingerprint
- dns (hostname):
  - port, dnssec, dns records
  - query also 1.1.1.1 and 8.8.8.8
  - let's encrypt record
  - google domain record
- whois (domain name)
- web (hostname - ip addresses taken from dns, ip address):
  - http: port, redirect, content body/response status, response headers
  - https: port, valid certificate, content body/response status, response headers
  - subdomain -> yet another host
- mail (hostname - ip addresses taken from dns, ip address):
  - pop3: port, test email
  - pop3s: ssl/tls, starttls, valid certificate, port, test email
  - imap: port, test email
  - imaps: ssl/tls, starttls, valid certificate, port, test email, LOGIN/to druhe
  - smtp
  - smtps
  - spf
  - dkim
  - dmarc
- protocols:
  - ipv4
  - ipv6
  - onion

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/superbear`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Run

- clone
- `bin/superbear examples/myrtana.yml [files]`

## Installation [TO BE DONE]

Add this line to your application's Gemfile:

```ruby
gem 'superbear'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install superbear

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/superbear. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

Copyright (C) 2020-2024 Ivan Stana

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.

## Code of Conduct

Everyone interacting in the superbear project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/superbear/blob/master/CODE_OF_CONDUCT.md).
