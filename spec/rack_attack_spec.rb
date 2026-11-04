require "rails_helper"

RSpec.describe "Rack::Attack" do
  it "is mounted in the middleware stack" do
    expect(Rails.application.middleware).to include(Rack::Attack)
  end

  it "uses an in-memory cache store in the test environment" do
    expect(Rack::Attack.cache.store).to be_a(ActiveSupport::Cache::MemoryStore)
  end

  it "supports incrementing counters, required for throttling" do
    store = Rack::Attack.cache.store
    store.increment("rack::attack:test:counter", 1, expires_in: 1.minute)

    expect(store.read("rack::attack:test:counter")).to eq(1)
  end
end
