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

    # Get an access if the rate limit is not exeeded
    # @param [String] client The value of the subject to track : 1234, foo@bar.com, 127.0.0.1
    # @return [Hash] Access ticket
    def get_access(client)
      current_time = Time.current
      range = current_time.strftime(@format)
      reset = current_time.to_i + @interval - (current_time.to_i % @interval)
      key_client = key(client)
      counter = @redis.hincrby(key_client, range, 1)

      if counter < @limit
        pass = true
        remaining = @limit - counter
      else
        pass = false
        remaining = 0
      end

      {
        'pass' => pass,
        'RateLimit' =>
        {
          'X-RateLimit-Limit' => @limit,
          'X-RateLimit-Remaining' => remaining,
          'X-RateLimit-Counter' => counter,
          'X-RateLimit-Reset' => reset
        }
      }
    end

    # Get an access if the rate limit is not exeeded or wait few seconds
    # @param [String] client The value of the subject to track : 1234, foo@bar.com, 127.0.0.1
    # @return [Hash] Access ticket
    def get_access_or_wait(client)
      result = get_access(client)
      return result if result['pass']
      time_to_sleep = result['RateLimit']['X-RateLimit-Reset'] - Time.current.to_i
      sleep(time_to_sleep)
      get_access(client)
    end

    # Get the access count for a given client within the current time range
    # @param [String] client The value of the subject to track : 1234, foo@bar.com, 127.0.0.1
    # @return [Integer] access count
    def counter(client)
      range = Time.current.strftime(@format)
      @redis.hget(key(client), range).to_i
    end

    # Get access history for a given client
    # @param [String] client The value of the subject to track : 1234, foo@bar.com, 127.0.0.1
    # @return [Array] Array of hash. key : time range, value : access counter
    def history(client)
      @redis.hgetall(key(client))
    end

    # Clean access history
    # @param [String] client The value of the subject to track : 1234, foo@bar.com, 127.0.0.1
    # @return [Integer] access count
    def clear(client)
      @redis.expire(key(client), 0)
    end

    private

    def key(client)
      "#{@ratelimit_name}:#{client}"
    end
  end
end
