require "rails_helper"

RSpec.describe Adapters::DeepSeekAdapter do
  subject(:adapter) { described_class.new }

  before do
    ENV["DEEPSEEK_API_KEY"] = "test-key"
    ENV["DEEPSEEK_MODEL"] = "deepseek-chat"
    ENV["DEEPSEEK_TEMPERATURE"] = "0.7"
  end

  describe "#message_to_chat_api" do
    it "returns the body on a successful response" do
      response = double("response", success?: true, body: '{"ok":true}')
      allow(HTTParty).to receive(:post).and_return(response)

      expect(adapter.message_to_chat_api([])).to eq('{"ok":true}')
    end

    it "raises ApiError on a non-successful response" do
      response = double("response", success?: false, code: 500, body: "error")
      allow(HTTParty).to receive(:post).and_return(response)

      expect { adapter.message_to_chat_api([]) }
        .to raise_error(Adapters::DeepSeekAdapter::ApiError, /status 500/)
    end

    it "raises ApiError on a network error" do
      allow(HTTParty).to receive(:post).and_raise(SocketError, "connection refused")

      expect { adapter.message_to_chat_api([]) }
        .to raise_error(Adapters::DeepSeekAdapter::ApiError, /request failed/)
    end
  end
end
