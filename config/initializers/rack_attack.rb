# frozen_string_literal: true

# Rate limiting middleware configuration.

# Rack::Attack uses Rails.cache (Redis) in production so throttling counters
# are shared across processes. In development and test it uses an in-memory
# store, which is simpler and resets between test examples.
Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new unless Rails.env.production?

# Throttle anonymous readings by IP to protect the LLM token budget.
# Adjust ANONYMOUS_READING_LIMIT to change how many anonymous readings a
# single IP can request per hour.
Rack::Attack.throttle(
  "anonymous_readings/ip",
  limit: ENV.fetch("ANONYMOUS_READING_LIMIT", "5").to_i,
  period: 1.hour
) do |req|
  req.ip if req.path == "/readings/anonymous" && req.post?
end

# Friendly response when a request is throttled.
Rack::Attack.throttled_responder = lambda do |_request|
  [ 429, { "Content-Type" => "text/plain; charset=utf-8" },
    [ "Demasiadas solicitudes. Intentá de nuevo más tarde." ] ]
end
