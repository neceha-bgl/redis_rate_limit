shared_examples 'shared behaviour' do
  let(:beginning_of_day) { Time.now.beginning_of_day }
  let(:client) { "127.0.0.1" }
  let(:options) { {redis: Redis.new} }

  def minutes(i)
    beginning_of_day + i * 60
  end

end
