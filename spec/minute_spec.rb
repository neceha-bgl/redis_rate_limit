require 'spec_helper'
require 'shared_spec_helper'

describe RedisRateLimit::Minute do
  include_examples 'shared behaviour'
  subject { RedisRateLimit::Minute.new('clients', options) }

  describe '.initialize' do
    it { is_expected.to be_kind_of(RedisRateLimit::Minute) }
    it do
      expect(subject.instance_variable_get(:@format)).to eq('%Y-%m-%dT%H:%M')
    end
    it { expect(subject.instance_variable_get(:@interval)).to eq(60) }
    it { expect(subject.instance_variable_get(:@limit)).to eq(60) }
  end

  describe '#history' do
    before(:each) do
      3.times do |i|
        Timecop.travel(minutes(i)) do
          10.times { subject.get_access(client) }
        end
      end
    end

    it 'returns 3 entries' do
      history = subject.history(client)
      expect(history.keys.size).to eql(3)
    end
  end
end
