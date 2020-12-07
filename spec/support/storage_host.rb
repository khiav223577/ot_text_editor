# frozen_string_literal: true

RSpec.configure do |config|
  config.before do
    Rails.application.routes.default_url_options[:host] = 'example.test.org'
    allow(ActiveStorage::Current).to receive(:host).and_return('example.test.org')
  end
end
