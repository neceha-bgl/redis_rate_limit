require "spec_helper"

describe RedisRateLimit::Period do
  let(:client) { "127.0.0.1" }
  let(:options) { {redis: Redis.new} }
  subject { RedisRateLimit::Period.new('clients', options) }

  describe '.initialize' do
    context 'with specific values' do
      let(:options) { {format: '%Y-%m-%dT%H', interval: 60, limit: 10, redis: Redis.new} }

      it { is_expected.to be_kind_of(RedisRateLimit::Period) }
      it { expect(subject.instance_variable_get(:@format)).to eq('%Y-%m-%dT%H') }
      it { expect(subject.instance_variable_get(:@interval)).to eq(60) }
      it { expect(subject.instance_variable_get(:@limit)).to eq(10) }
    end

    context 'with default values' do
      it { is_expected.to be_kind_of(RedisRateLimit::Period) }
      it { expect(subject.instance_variable_get(:@format)).to eq('%Y-%m-%dT%H:%M') }
      it { expect(subject.instance_variable_get(:@interval)).to eq(60) }
      it { expect(subject.instance_variable_get(:@limit)).to eq(60) }
    end
  end
end
