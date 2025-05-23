# config/puma.rb

# Configure the number of threads per Puma worker
threads_count = ENV.fetch("RAILS_MAX_THREADS", 3)
threads threads_count, threads_count

# Port to listen on (Render provides the port via the PORT environment variable)
port ENV.fetch("PORT", 3000)

# Set the environment (Render sets RAILS_ENV=production)
environment ENV.fetch("RAILS_ENV", "development")

# Specify the PID file (optional, useful for restarts)
pidfile ENV["PIDFILE"] if ENV["PIDFILE"]

# Number of Puma workers (Render supports multiple processes)
workers ENV.fetch("WEB_CONCURRENCY", 2)

# Preload the application before forking workers for better performance
preload_app!

# Allow Puma to be restarted by the `bin/rails restart` command
plugin :tmp_restart
