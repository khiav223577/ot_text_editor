class JobTestHelper
  include ActiveJob::TestHelper
end

RSpec.configure do |config|
  config.before do
    ActionMailer::Base.deliveries.clear
  end

  config.around(:each, :inline_jobs) do |example|
    JobTestHelper.new.perform_enqueued_jobs { example.run }
  end

  config.after do
    ActiveJob::Base.queue_adapter.enqueued_jobs.clear
  end
end
