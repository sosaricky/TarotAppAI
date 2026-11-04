require "rails_helper"

RSpec.describe LlmOutputNormalizer do
  describe ".parse_output" do
    it "extracts the JSON object from surrounding text" do
      raw = 'Here is your reading: {"name":"Path of Love","cards":["The Fool"]} thanks!'

      expect(described_class.parse_output(raw))
        .to eq('{"name":"Path of Love","cards":["The Fool"]}')
    end

    it "returns the input unchanged when no JSON object is present" do
      raw = "I could not generate a reading today."

      expect(described_class.parse_output(raw)).to eq(raw)
    end

    it "strips surrounding whitespace from the extracted JSON" do
      raw = "  {\"name\":\"Path of Love\"}  "

      expect(described_class.parse_output(raw))
        .to eq("{\"name\":\"Path of Love\"}")
    end
  end
end
