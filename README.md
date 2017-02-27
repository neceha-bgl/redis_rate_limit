# RedisRateLimit

[![Build Status](https://secure.travis-ci.org/neceha-bgl/redis_rate_limit.svg?branch=master)](http://travis-ci.org/neceha-bgl/redis_rate_limit)
[![Code Climate](https://codeclimate.com/github/neceha-bgl/redis_rate_limit/badges/gpa.svg)](https://codeclimate.com/github/neceha-bgl/redis_rate_limit)
[![Issue Count](https://codeclimate.com/github/neceha-bgl/redis_rate_limit/badges/issue_count.svg)](https://codeclimate.com/github/neceha-bgl/redis_rate_limit)
[![Test Coverage](https://lima.codeclimate.com/github/neceha-bgl/redis_rate_limit/badges/coverage.svg)](https://lima.codeclimate.com/github/neceha-bgl/redis_rate_limit/coverage)

Action rate limits are applied at a per-key basis in unit time (minutes, hourly, daily ...). By using Redis, this library allows to control actions across multiple servers

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'redis_rate_limit'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install redis_rate_limit

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/redis_rate_limit.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

