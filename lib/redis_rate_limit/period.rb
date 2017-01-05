module RedisRateLimit
  class Period

    # Create an instance of Period.
    # @param [String] name A unique namespace that identify the subject to track : users, emails, ip ...
    # @param [Hash] options Options hash
    # @option options [String]  :format ('%Y-%m-%dT%H:%M') Formated date that represents the time span to track
    # @option options [Integer] :interval (60) The duration in seconds before the next reset
    # @option options [Integer] :limit (60) How many transactions to perform during the defined interval
    # @option options [Redis]   :redis (nil) Redis client
    # @return [Period] Period instance
    def initialize(name, options = {})
      @ratelimit_name = "rate_limit:#{name}"
      @format = options[:format] || '%Y-%m-%dT%H:%M'
      @interval = options[:interval] || 60
      @limit = options[:limit] || @interval
      @redis = options[:redis]
    end
  end
end

