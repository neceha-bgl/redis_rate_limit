require 'spec_helper'
require 'shared_spec_helper'

describe RedisRateLimit::Period do
  include_examples 'shared behaviour'
  subject { RedisRateLimit::Period.new('clients', options) }

  describe '.initialize' do
    context 'with specific values' do
      let(:options) do
        {
          format: '%Y-%m-%dT%H',
          interval: 60,
          limit: 10,
          redis: Redis.new
        }
      end

      it { is_expected.to be_kind_of(RedisRateLimit::Period) }
      it do
        expect(subject.instance_variable_get(:@format)).to eq('%Y-%m-%dT%H')
      end
      it { expect(subject.instance_variable_get(:@interval)).to eq(60) }
      it { expect(subject.instance_variable_get(:@limit)).to eq(10) }
    end

    context 'with default values' do
      it { is_expected.to be_kind_of(RedisRateLimit::Period) }
      it do
        expect(subject.instance_variable_get(:@format)).to eq('%Y-%m-%dT%H:%M')
      end
      it { expect(subject.instance_variable_get(:@interval)).to eq(60) }
      it { expect(subject.instance_variable_get(:@limit)).to eq(60) }
    end
  end

  describe '#get_access' do
    context 'When the rate limit is not exceeded' do
      let(:access) { subject.get_access(client) }
      it 'get a pass' do
        expect(access['pass']).to be true
      end

      it 'decrement the rate limit' do
        expect(access['RateLimit']['X-RateLimit-Remaining']).to eql(59)
      end
    end

    context 'When the rate limit is exceeded' do
      before(:each) do
        60.times { subject.get_access(client) }
      end

      it 'fails to get a pass' do
        access = subject.get_access(client)
        expect(access['pass']).to be false
      end

      it 'set the remaining to zero' do
        access = subject.get_access(client)
        expect(access['RateLimit']['X-RateLimit-Remaining']).to eql(0)
      end

      it 'get a pass when the reset time is reached' do
        Timecop.travel(minutes(1)) do
          access = subject.get_access(client)
          expect(access['pass']).to be true
        end
      end
    end
  end

  describe '#counter' do
    before(:each) do
      20.times { subject.get_access(client) }
    end

    context 'Before the rate limit reset' do
      it { expect(subject.counter(client)).to eq(20) }
    end

    context 'After the rate limit reset' do
      it do
        Timecop.travel(minutes(1)) do
          expect(subject.counter(client)).to eq(0)
        end
      end
    end
  end

  describe '#history' do
    before(:each) do
      Timecop.travel(minutes(0)) do
        5.times { subject.get_access(client) }
      end

      Timecop.travel(minutes(1)) do
        10.times { subject.get_access(client) }
      end

      Timecop.travel(minutes(2)) do
        61.times { subject.get_access(client) }
      end
    end

    it 'returns 3 entries' do
      history = subject.history(client)
      expect(history.keys.size).to eql(3)
    end

    it 'returns a correct global counter' do
      global_counter = subject.history(client).values.map(&:to_i).inject(:+)
      expect(global_counter).to eql(76)
    end
  end

  describe '#clear' do
    before(:each) do
      3.times do |i|
        Timecop.travel(minutes(i)) do
          10.times { subject.get_access(client) }
        end
      end
    end

    it 'returns 3 entries before clearing' do
      history = subject.history(client)
      expect(history.keys.size).to eql(3)
    end

    it 'returns 0 entry after clearing' do
      subject.clear(client)
      history = subject.history(client)
      expect(history.keys.size).to eql(0)
    end
  end

  describe '#get_access_or_wait' do
    context 'When the rate limit is not exceeded' do
      let(:access) { subject.get_access_or_wait(client) }
      it 'get a pass' do
        expect(access['pass']).to be true
      end
    end

    context 'When the rate limit is exceeded' do
      before(:each) do
        60.times { @pass1 = subject.get_access(client) }
      end

      it 'get a pass after sleeping few seconds' do
        time_to_sleep = @pass1['RateLimit']['X-RateLimit-Reset'] - Time.now.to_i
        allow(subject).to receive(:sleep).with(anything) {
          Timecop.travel(Time.current + time_to_sleep)
        }
        access = subject.get_access_or_wait(client)
        expect(access['pass']).to be true
      end
    end
  end
end
