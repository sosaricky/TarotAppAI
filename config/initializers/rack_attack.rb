# frozen_string_literal: true

# Rate limiting middleware configuration.
# Throttle rules will be added in subsequent steps.

# Rack::Attack uses Rails.cache (Redis) in production so throttling counters
# are shared across processes. In development and test it uses an in-memory
# store, which is simpler and resets between test examples.
Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new unless Rails.env.production?
