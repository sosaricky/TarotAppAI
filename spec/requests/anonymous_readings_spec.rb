require "rails_helper"

RSpec.describe "Anonymous readings", type: :request do
  let(:service) { instance_double(ReadingGeneratorService) }

  before do
    allow(ReadingGeneratorService).to receive(:new).and_return(service)
  end

  describe "GET / (home)" do
    it "renders a form that posts to the anonymous readings endpoint" do
      get root_path

      expect(response.body).to include('action="/readings/anonymous"')
      expect(response.body).to include('method="post"')
    end
  end

  describe "POST /readings/anonymous" do
    it "creates a reading and redirects to it without requiring sign in" do
      reading = create(:reading, user: nil)
      allow(service).to receive(:call).and_return(reading)

      post anonymous_readings_path

      expect(response).to redirect_to(reading_path(reading))
    end
  end

  describe "GET /readings/:id for an anonymous reading" do
    it "is accessible without signing in" do
      reading = create(:reading, user: nil)
      create(:reading_card, reading: reading, card: create(:card), position: 0, message: "A message")

      get reading_path(reading)

      expect(response).to have_http_status(:ok)
    end
  end
end
