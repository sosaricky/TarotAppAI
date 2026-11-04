require "rails_helper"

RSpec.describe ReadingGeneratorService do
  subject(:service) { described_class.new(user.id, adapter) }

  let(:user) { create(:user) }

  # A plain test double that fakes the DeepSeek API response.
  let(:adapter) do
    double("Adapters::DeepSeekAdapter", message_to_chat_api: api_response.to_json)
  end

  let(:api_response) do
    {
      choices: [
        {
          message: {
            content: {
              name: "Path of Love",
              cards: [ "El Loco", "El Mago", "La Estrella" ],
              messages: [ "message one", "message two", "message three" ],
              conclusion: "A conclusion"
            }.to_json
          }
        }
      ]
    }
  end

  it "creates a reading with three cards for the user" do
    expect { service.call }
      .to change(Reading, :count).by(1)
      .and change(ReadingCard, :count).by(3)

    reading = Reading.last
    expect(reading.user).to eq(user)
    expect(reading.cards.count).to eq(3)
    expect(reading.cards.map(&:name))
      .to contain_exactly("El Loco", "El Mago", "La Estrella")
  end

  it "stores each card's message on the reading card" do
    service.call

    messages = Reading.last.reading_cards.order(:position).pluck(:message)
    expect(messages).to eq([ "message one", "message two", "message three" ])
  end

  it "reuses existing cards instead of duplicating them across readings" do
    expect { service.call }.to change(Card, :count).by(3)

    expect { service.call }
      .to change(Reading, :count).by(1)
      .and change(Card, :count).by(0)
  end
end
