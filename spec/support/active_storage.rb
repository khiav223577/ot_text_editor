RSpec.configure do |config|
  config.before do
    allow(ActiveStorage::Current).to receive(:host).and_return("test.example.org")
  end

  config.after(:suite) do
    FileUtils.rm_rf("tmp/storage")
  end
end
