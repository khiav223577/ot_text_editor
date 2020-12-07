RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
    RequestStore.clear!
  end

  config.after(:each) do
    DatabaseCleaner.clean
  rescue NoMethodError => e # See: https://github.com/DatabaseCleaner/database_cleaner-sequel/issues/4
    next puts("Warning: catch #{e.message}") if e.message == %(undefined method `rollback' for nil:NilClass)
    raise e
  end
end
