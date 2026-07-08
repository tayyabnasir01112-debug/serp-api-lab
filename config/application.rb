require_relative "boot"

require "rails"
require "active_model/railtie"
require "active_record/railtie"
require "active_job/railtie"
require "action_controller/railtie"
require "active_support/railtie"

Bundler.require(*Rails.groups)

module SerpApiLab
  class Application < Rails::Application
    config.load_defaults 7.2
    config.api_only = true
    config.autoload_lib(ignore: %w[assets tasks])
    config.active_record.schema_format = :ruby
    config.active_job.queue_adapter = :sidekiq
    config.time_zone = "UTC"

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins "*"
        resource "*", headers: :any, methods: %i[get options]
      end
    end
  end
end
