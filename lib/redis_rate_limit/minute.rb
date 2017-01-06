module RedisRateLimit
  class Minute < Period

    # Create an instance of Minute
    # @param [String] name A unique namespace that identify the subject to track : users, emails, ip ...
    # @param [Hash] options Options hash
    # @option options [Integer] :limit (60) How many transactions to perform during the defined interval
    # @option options [Redis]   :redis (nil) Redis client
    # @return [Minute] Minute instance
    def initialize(name, options = {})
      super(name, options.merge({format: '%Y-%m-%dT%H:%M', interval: 60}))
    end

  end
end

