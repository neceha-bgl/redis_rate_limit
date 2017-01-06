module RedisRateLimit
  class Hourly < Period

    # Create an instance of Hourly
    # @param [String] name A unique namespace that identify the subject to track : users, emails, ip ...
    # @param [Hash] options Options hash
    # @option options [Integer] :limit (3600) How many transactions to perform during the defined interval
    # @option options [Redis]   :redis (nil) Redis client
    # @return [Hourly] Hourly instance
    def initialize(name, options = {})
      super(name, options.merge({format: '%Y-%m-%dT%H', interval: 3600}))
    end

  end
end

