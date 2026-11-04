class ReadingGeneratorService
  attr_reader :user, :adapter

  def initialize(user_id, adapter)
    @user = User.find(user_id)
    @adapter = adapter
  end

  def call
    response = adapter.message_to_chat_api(TarotPrompt.new.request_messages)
    create_reading(response)
  end

  private

  def create_reading(response)
    parsed_response = JSON.parse(response)
    reading_content = parsed_response.dig("choices", 0, "message", "content")
    cleaned_reading = LlmOutputNormalizer.parse_output(reading_content)
    reading_data = JSON.parse(cleaned_reading)

    card_names = reading_data["cards"]
    card_messages = reading_data["messages"]
    cards_with_messages = card_names.zip(card_messages)

    reading = nil
    ActiveRecord::Base.transaction do
      reading = Reading.create!(
        name: reading_data["name"],
        conclusion: reading_data["conclusion"],
        user: user
      )

      cards_with_messages.each_with_index do |(name, message), index|
        card = Card.find_or_create_by!(name: name) do |new_card|
          new_card.message = message
          new_card.image_path = ImagePathGeneratorService.get_path_of_card(name)
        end

        reading.reading_cards.create!(
          card: card,
          position: index,
          reversed: [ false, true ].sample
        )
      end
    end

    reading
  end
end
