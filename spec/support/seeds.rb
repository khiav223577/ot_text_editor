RSpec.configure do |config|
  config.before(:suite) do
    Rails.application.load_seed # loading seeds

    # Add custom seed for test cases below this line.
  end
end
