Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local = false
  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info").to_sym
  config.force_ssl = ENV.fetch("RAILS_FORCE_SSL", "false") == "true"
  config.active_record.dump_schema_after_migration = false
  config.secret_key_base = ENV.fetch("SECRET_KEY_BASE")
end
