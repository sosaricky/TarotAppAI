require_relative "adapters/deep_seek_adapter"

class ReadingGeneratorService
  attr_reader :user, :adapter

  def initialize(user_id, adapter)
    @user = User.find(user_id)
    @adapter = adapter
  end

  def call
    # check_valid_message_length
    response = adapter.message_to_chat_api(request_messages)
    create_reading(response)
  end

  private

  def check_valid_message_length
    error_msg = "Longitud invalida"
    raise ReadingGeneratorServiceError, error_msg unless !!(message =~ /\b\w+\b/)
  end

  def request_messages
    system_message + user_message
  end

  def user_prompt
    <<~CONTENT
      Hazme una lectura de tarot para esta semana.Necesito que la respuesta sea en formato json, con la
      siguiente estructura:
      {
        "name" : "nombre o título que le pondrías a la lectura"
        "cards" : [nombre_de_la_primera_carta,nombre_de_la_segunda_carta,nombre_de_la_tercer_carta]
        "messages" : [mensaje_de_la_primera_carta,mensaje_de_la_segunda_carta,mensaje_de_la_tercer_carta]
        "conclusion" : "la conclusión de la lectura"
      }
      Además, no repitas lecturas.
    CONTENT
  end

  def system_prompt
    <<~CONTENT
      Sos un tarotista profesional que responde con una lectura breve de 3 cartas.
    CONTENT
  end

  def system_message
    [ { 'role': "system", 'content': system_prompt } ]
  end

  def user_message
    [ { 'role': "user", 'content': user_prompt } ]
  end

  def create_reading(response)
    parsed_response = response.is_a?(String) ? JSON.parse(response) : response
    content_parsed = CodeSnippetParser.parse_snippet((parsed_response.dig("choices", 0, "message", "content")))
    json_parsed = JSON.parse(content_parsed)

    cards = []
    card_names = json_parsed["cards"]
    card_messages = json_parsed["messages"]
    cards_with_messages_names = card_names.zip(card_messages)

    cards_with_messages_names.each_with_index do
      |(name, message), index|
      card = Card.new(name: name, message: message, image_path: ImagePathGeneratorService.get_path_of_card(name))
      cards << card
      card.save!
    end

    reading = Reading.new(name: json_parsed["name"], conclusion: json_parsed["conclusion"], user: user)
    reading.save!
    cards.each_with_index do
      |card, index_card|
      reading_card = ReadingCard.new(
        reading_id: reading.id,
        card_id: card.id,
        position: index_card,
        reversed: [ false, true ].sample
      )
      reading_card.save!
    end
    reading
  end
end
