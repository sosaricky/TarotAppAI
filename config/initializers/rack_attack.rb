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

# A themed page shown when a request is throttled, matching the site's look.
THROTTLED_RESPONSE_HTML = <<~HTML
  <!DOCTYPE html>
  <html lang="es">
    <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <title>Tarot</title>
      <link rel="preconnect" href="https://fonts.googleapis.com">
      <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
      <link href="https://fonts.googleapis.com/css2?family=Cinzel+Decorative:wght@400;700&family=Cormorant+SC:wght@400;600&display=swap" rel="stylesheet">
      <style>
        * { box-sizing: border-box; }
        body {
          margin: 0;
          min-height: 100vh;
          display: flex;
          align-items: center;
          justify-content: center;
          background-color: #121017;
          color: #f8f1e5;
          font-family: 'Cormorant SC', serif;
          text-align: center;
          padding: 2rem;
        }
        .card { max-width: 600px; }
        .card h1 {
          font-family: 'Cinzel Decorative', serif;
          color: #ffd700;
          font-size: 2.2rem;
          font-weight: 400;
          margin: 0 0 1.5rem;
        }
        .card p {
          font-size: 1.35rem;
          line-height: 1.6;
          color: #b5b0a8;
          margin: 0 0 0.75rem;
        }
        .card .hint {
          font-family: 'Cinzel Decorative', serif;
          font-size: 1.05rem;
          color: #ffd700;
          margin: 0 0 2rem;
        }
        .card a {
          display: inline-block;
          font-family: 'Cinzel Decorative', serif;
          color: #ffd700;
          text-decoration: none;
          border: 1px solid #b5b0a8;
          padding: 0.75rem 1.5rem;
          border-radius: 6px;
        }
        .card a:hover { border-color: #ffd700; }
      </style>
    </head>
    <body>
      <div class="card">
        <h1>Tarot</h1>
        <p>La calma es tan importante como la necesidad de saber el futuro.</p>
        <p class="hint">Intentá más tarde.</p>
        <a href="/">← Volver al inicio</a>
      </div>
    </body>
  </html>
HTML

Rack::Attack.throttled_responder = lambda do |_request|
  [ 429, { "Content-Type" => "text/html; charset=utf-8" }, [ THROTTLED_RESPONSE_HTML ] ]
end
