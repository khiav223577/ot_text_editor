RSpec.configure do |config|
  config.before(:suite) do
    Timecop.freeze(Time.parse("2018-07-03T00:12:54.000Z"))
  end

  config.after(:suite) do
    Timecop.return
  end
end
