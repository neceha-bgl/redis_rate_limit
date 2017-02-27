module RedisRateLimit
  class Daily < Period
    # Create an instance of Daily
    # @param [String] name A unique namespace that identify the subject to track : users, emails, ip ...
    # @param [Hash] options Options hash
    # @option options [Integer] :limit (86_400) How many transactions to perform during the defined interval
    # @option options [Redis]   :redis (nil) Redis client
    # @return [Daily] Daily instance
    def initialize(name, options = {})
      super(name, options.merge(format: '%Y-%m-%d', interval: 86_400))
    end
  end
end
