require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module OtTextEditor
  class Application < Rails::Application
    config.action_mailer.smtp_settings = {
      address: Settings.mailer_smtp_address,
      port: Settings.mailer_smtp_port,
      domain: Settings.mailer_smtp_domain,
      authentication: Settings.mailer_smtp_authentication,
      enable_starttls_auto: Settings.mailer_smtp_enable_starttls_auto,
      user_name: Settings.mailer_smtp_user_name,
      password: Settings.mailer_smtp_password,
    }
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.default_url_options = {
      host: Settings.mailer_server_host,
      port: Settings.mailer_server_port,
      protocol: Settings.mailer_server_protocol,
    }
    config.middleware.use Rack::Cors do
      allow do
        origins Settings.cors_origins
        resource '*',
                 headers: :any,
                 expose: %w[access-token expiry token-type uid client],
                 methods: [:get, :post, :options, :delete, :put]
      end
    end
    config.time_zone = Settings.time_zone
    config.generators do |g|
      g.test_framework :rspec,
                       fixtures: true,
                       view_specs: false,
                       helper_specs: true,
                       routing_specs: false,
                       controller_specs: false,
                       request_specs: true,
                       mailer_specs: false
    end
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
  end
end
