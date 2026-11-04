require "rails_helper"

RSpec.describe "Rate limiting", type: :request do
  let(:service) { instance_double(ReadingGeneratorService) }
  let(:limit) { ENV.fetch("ANONYMOUS_READING_LIMIT", "5").to_i }

  before do
    allow(ReadingGeneratorService).to receive(:new).and_return(service)
    allow(service).to receive(:call).and_return(create(:reading, user: nil))
  end

  describe "POST /readings/anonymous" do
    it "allows requests up to the limit" do
      limit.times { post anonymous_readings_path }

      expect(response).to have_http_status(:redirect)
    end

    it "throttles requests beyond the limit from the same IP" do
      limit.times { post anonymous_readings_path }

      post anonymous_readings_path

      expect(response).to have_http_status(:too_many_requests)
      expect(response.media_type).to eq("text/html")
      expect(response.body).to include("La calma es tan importante")
      expect(response.body).to include("Intentá más tarde")
      expect(response.body).to include("Volver al inicio")
    end
  end
end
