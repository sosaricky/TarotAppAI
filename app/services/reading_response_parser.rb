# frozen_string_literal: true

# Parses and validates the raw response returned by the DeepSeek adapter.
# It raises a controlled error when the payload is malformed, incomplete, or
# references cards outside the known major arcana.
class ReadingResponseParser
  class InvalidResponseError < StandardError; end

  REQUIRED_KEYS = %w[name cards messages conclusion].freeze

  def self.call(raw_response)
    new(raw_response).call
  end

  def initialize(raw_response)
    @raw_response = raw_response
  end

  def call
    payload = JSON.parse(LlmOutputNormalizer.parse_output(extract_content))
    validate!(payload)
    payload
  rescue JSON::ParserError => e
    raise InvalidResponseError, "The LLM returned invalid JSON: #{e.message}"
  end

  private

  attr_reader :raw_response

  def extract_content
    outer = JSON.parse(raw_response)
    content = outer.dig("choices", 0, "message", "content")
    raise InvalidResponseError, "The LLM response is missing message content" if content.blank?

    content
  end

  def validate!(payload)
    REQUIRED_KEYS.each do |key|
      raise InvalidResponseError, "Missing required key: #{key}" if payload[key].blank?
    end

    cards = Array(payload["cards"])
    messages = Array(payload["messages"])

    if cards.length != messages.length
      raise InvalidResponseError, "cards and messages must have the same length"
    end

    unknown_cards = cards - Card::MAJOR_ARCANA_NAMES
    if unknown_cards.any?
      raise InvalidResponseError, "Unknown card names: #{unknown_cards.join(', ')}"
    end
  end
end
