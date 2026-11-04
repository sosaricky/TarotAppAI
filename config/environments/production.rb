require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.enable_reloading = false

  # Eager load code on boot. This loads most of Rails and your application
  # into memory, improving performance for threaded web servers
  # and those using copy-on-write.
  config.eager_load = true

  # Disable full error reports and enable caching.
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  # Ensure a master key is available in ENV["RAILS_MASTER_KEY"], config/master.key,
  # or an environment-specific credentials file. Asset precompilation sets
  # SECRET_KEY_BASE_DUMMY, which lets the build run without the real key.
  config.require_master_key = ENV["SECRET_KEY_BASE_DUMMY"].blank?

  # Enable serving static files from the /public folder when the ENV variable is present.
  # Required for platforms like Render.
  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?

  # Do not fall back to asset pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.asset_host = "http://assets.example.com"

  # Specifies the header used by the server for sending files.
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for Apache
  # config.action_dispatch.x_sendfile_header = "X-Accel-Redirect" # for NGINX

  # Store uploaded files on the local file system (see config/storage.yml for options).
  # This may not persist across deploys on platforms like Render.
  config.active_storage.service = :local

  # Mount Action Cable outside main process or domain.
  # config.action_cable.mount_path = nil
  # config.action_cable.url = "wss://example.com/cable"
  # config.action_cable.allowed_request_origins = [ "http://example.com", /http:\/\/example.*/ ]

  # Assume requests are sent via a reverse proxy that terminates SSL.
  # config.assume_ssl = true

  # Enforce HTTPS with secure cookies and HSTS.
  config.force_ssl = true

  # Skip HTTP-to-HTTPS redirect for health check endpoint.
  # config.ssl_options = { redirect: { exclude: ->(request) { request.path == "/up" } } }

  # Log to STDOUT by default, which is standard in cloud platforms.
  config.logger = ActiveSupport::Logger.new(STDOUT)
    .tap  { |logger| logger.formatter = ::Logger::Formatter.new }
    .then { |logger| ActiveSupport::TaggedLogging.new(logger) }

  # Prepend all log lines with the following tags.
  config.log_tags = [ :request_id ]

  # Set log level. "info" is typical for production.
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  # Use a shared Redis cache store so Rack::Attack throttling counters are
  # consistent across multiple processes/instances.
  config.cache_store = :redis_cache_store, { url: ENV.fetch("REDIS_URL") { "redis://localhost:6379/0" } }

  # Use a real queuing backend for Active Job.
  # config.active_job.queue_adapter = :resque
  # config.active_job.queue_name_prefix = "tarot_app_ai_production"

  # Disable caching for Action Mailer views.
  config.action_mailer.perform_caching = false

  # Ignore delivery errors for Action Mailer.
  # config.action_mailer.raise_delivery_errors = false

  # Enable locale fallbacks for I18n.
  config.i18n.fallbacks = true

  # Suppress deprecation warnings in logs.
  config.active_support.report_deprecations = false

  # Do not dump the schema after migrations.
  config.active_record.dump_schema_after_migration = false

  # Enable DNS rebinding protection.
  # config.hosts = [
  #   "example.com",
  #   /.*\.example\.com/
  # ]

  # Skip DNS rebinding protection for the health check endpoint.
  # config.host_authorization = { exclude: ->(request) { request.path == "/up" } }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
  address: "smtp.mailgun.org",
  port: 587,
  domain: ENV["MAILGUN_DOMAIN"],
  user_name: ENV["MAILGUN_USERNAME"],
  password: ENV["MAILGUN_PASSWORD"],
  authentication: "plain",
  enable_starttls_auto: true
}

config.action_mailer.default_url_options = {
  host: ENV["APP_DOMAIN"], protocol: "https"
}
end
