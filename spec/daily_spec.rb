require 'spec_helper'
require 'shared_spec_helper'

describe RedisRateLimit::Daily do
  include_examples 'shared behaviour'
  subject { RedisRateLimit::Daily.new('clients', options) }

  describe '.initialize' do
    it { is_expected.to be_kind_of(RedisRateLimit::Daily) }
    it { expect(subject.instance_variable_get(:@format)).to eq('%Y-%m-%d') }
    it { expect(subject.instance_variable_get(:@interval)).to eq(86_400) }
    it { expect(subject.instance_variable_get(:@limit)).to eq(86_400) }
  end

  describe '#history' do
    context 'within the day' do
      before(:each) do
        3.times do |i|
          Timecop.travel(hours(i)) do
            10.times { subject.get_access(client) }
          end
        end
      end

      it 'returns 1 entry' do
        history = subject.history(client)
        expect(history.keys.size).to eql(1)
      end
    end

    context 'more than one day' do
      before(:each) do
        2.times do |i|
          Timecop.travel(hours(i)) do
            10.times { subject.get_access(client) }
          end
        end

        3.times do |i|
          Timecop.travel(days(i)) do
            10.times { subject.get_access(client) }
          end
        end
      end

      it 'returns many entries' do
        history = subject.history(client)
        expect(history.keys.size).to eql(3)
      end
    end
  end
end
