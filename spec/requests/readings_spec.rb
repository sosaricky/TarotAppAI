require "rails_helper"

RSpec.describe "Readings", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user) }
  let(:service) { instance_double(ReadingGeneratorService) }

  before do
    sign_in user
    allow(ReadingGeneratorService).to receive(:new).and_return(service)
  end

  describe "GET /readings/:id" do
    let(:reading) { create(:reading, user: user) }
    let(:card) { create(:card) }

    before do
      create(:reading_card, reading: reading, card: card, position: 0, message: "A message")
    end

    it "renders the card image, its text, and the conclusion" do
      get reading_path(reading)

      expect(response.body).to include('/images/cards/The Fool.jpg')
      expect(response.body).to include("A message")
      expect(response.body).to include(reading.conclusion)
    end
  end

  describe "POST /readings" do
    context "when the reading is generated successfully" do
      let(:reading) { create(:reading) }

      before do
        allow(service).to receive(:call).and_return(reading)
      end

      it "redirects to the newly created reading" do
        post readings_path

        expect(response).to redirect_to(reading_path(reading))
      end
    end

    context "when the LLM response is invalid" do
      before do
        allow(service).to receive(:call)
          .and_raise(ReadingResponseParser::InvalidResponseError, "Unknown card names: Carta Inventada")
      end

      it "redirects to the dashboard with an alert instead of raising a 500" do
        post readings_path

        expect(response).to redirect_to(dashboard_path)
        expect(flash[:alert]).to be_present
      end
    end

    context "when the DeepSeek API request fails" do
      before do
        allow(service).to receive(:call)
          .and_raise(Adapters::DeepSeekAdapter::ApiError, "DeepSeek API request failed")
      end

      it "redirects to the dashboard with an alert instead of raising a 500" do
        post readings_path

        expect(response).to redirect_to(dashboard_path)
        expect(flash[:alert]).to be_present
      end
    end
  end
end
