require "rails_helper"

RSpec.describe ReadingResponseParser do
  let(:content) do
    {
      name: "Path of Love",
      cards: [ "El Loco", "El Mago", "La Estrella" ],
      messages: [ "message one", "message two", "message three" ],
      conclusion: "A conclusion"
    }.to_json
  end

  let(:raw_response) do
    {
      choices: [
        { message: { content: content } }
      ]
    }.to_json
  end

  describe ".call" do
    it "returns the parsed payload for a valid response" do
      payload = described_class.call(raw_response)

      expect(payload["name"]).to eq("Path of Love")
      expect(payload["cards"]).to eq([ "El Loco", "El Mago", "La Estrella" ])
    end

    it "extracts the JSON when the LLM wraps it in extra text" do
      wrapped_content = "Sure! Here it is: #{content} hope it helps."
      wrapped_response = {
        choices: [ { message: { content: wrapped_content } } ]
      }.to_json

      payload = described_class.call(wrapped_response)

      expect(payload["cards"]).to eq([ "El Loco", "El Mago", "La Estrella" ])
    end

    it "raises a controlled error when the outer response is not JSON" do
      expect { described_class.call("not json") }
        .to raise_error(ReadingResponseParser::InvalidResponseError, /invalid JSON/i)
    end

    it "raises a controlled error when the message content is missing" do
      response = { choices: [ { message: {} } ] }.to_json

      expect { described_class.call(response) }
        .to raise_error(ReadingResponseParser::InvalidResponseError, /missing message content/i)
    end

    it "raises a controlled error when a required key is missing" do
      incomplete = content_without("conclusion")

      expect { described_class.call(incomplete) }
        .to raise_error(ReadingResponseParser::InvalidResponseError, /Missing required key: conclusion/)
    end

    it "raises a controlled error when a card is not in the major arcana" do
      invalid = content_with_cards([ "El Loco", "El Mago", "Carta Inventada" ])

      expect { described_class.call(invalid) }
        .to raise_error(ReadingResponseParser::InvalidResponseError, /Unknown card names: Carta Inventada/)
    end

    it "raises a controlled error when cards and messages lengths differ" do
      invalid = content_with(
        cards: [ "El Loco", "El Mago", "La Estrella" ],
        messages: [ "only one message" ]
      )

      expect { described_class.call(invalid) }
        .to raise_error(ReadingResponseParser::InvalidResponseError, /same length/i)
    end
  end

  def content_without(key)
    payload = JSON.parse(content)
    payload.delete(key)
    { choices: [ { message: { content: payload.to_json } } ] }.to_json
  end

  def content_with_cards(cards)
    content_with(cards: cards)
  end

  def content_with(overrides)
    payload = JSON.parse(content).merge(overrides)
    { choices: [ { message: { content: payload.to_json } } ] }.to_json
  end
end
