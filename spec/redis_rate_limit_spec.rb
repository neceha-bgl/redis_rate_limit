require 'spec_helper'

describe RedisRateLimit do
  it 'has a version number' do
    expect(RedisRateLimit::VERSION).not_to be nil
  end
end
