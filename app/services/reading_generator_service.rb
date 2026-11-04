class ReadingGeneratorService
  attr_reader :user, :adapter

  def initialize(user, adapter)
    @user = user
    @adapter = adapter
  end

  def call
    raw_response = adapter.message_to_chat_api(TarotPrompt.new.request_messages)
    create_reading(ReadingResponseParser.call(raw_response))
  end

  private

  def create_reading(reading_data)
    card_names = reading_data["cards"]
    card_messages = reading_data["messages"]

    reading = nil
    ActiveRecord::Base.transaction do
      reading = Reading.create!(
        name: reading_data["name"],
        conclusion: reading_data["conclusion"],
        user: user
      )

      card_names.zip(card_messages).each_with_index do |(name, message), index|
        card = Card.find_or_create_by!(name: name)

        reading.reading_cards.create!(
          card: card,
          position: index,
          reversed: [ false, true ].sample,
          message: message
        )
      end
    end

    reading
  end
end
