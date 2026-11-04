require "rails_helper"

RSpec.describe TarotPrompt do
  describe "#request_messages" do
    subject(:messages) { described_class.new.request_messages }

    it "returns a system message followed by a user message" do
      expect(messages.map { |message| message[:role] }).to eq(%w[system user])
    end

    it "asks for a JSON response in the user message" do
      user_content = messages.last[:content]

      expect(user_content).to include('"name"')
      expect(user_content).to include('"cards"')
      expect(user_content).to include('"messages"')
      expect(user_content).to include('"conclusion"')
    end

    it "restricts the allowed card names to the known major arcana" do
      user_content = messages.last[:content]

      expect(user_content).to include("El Loco")
      expect(user_content).to include("La Estrella")
      expect(user_content).to include("El Mundo")
    end
  end
end
