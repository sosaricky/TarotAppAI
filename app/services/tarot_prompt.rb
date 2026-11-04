# Builds the messages sent to the LLM to request a tarot reading.
class TarotPrompt
  ALLOWED_CARD_NAMES = [
    "El Loco",
    "El Mago",
    "La Emperatriz",
    "La Fuerza",
    "La Muerte",
    "El Diablo",
    "La Luna",
    "El Sol",
    "La Torre",
    "El Juicio",
    "El Ermitaño",
    "La Rueda de la Fortuna",
    "La Sacerdotisa",
    "El Carro",
    "La Estrella",
    "La Justicia",
    "El Colgado",
    "La Templanza",
    "El Emperador",
    "El Papa",
    "El Mundo"
  ].freeze

  def request_messages
    [ system_message, user_message ]
  end

  private

  def system_message
    { role: "system", content: system_prompt }
  end

  def user_message
    { role: "user", content: user_prompt }
  end

  def system_prompt
    <<~CONTENT
      Sos un tarotista profesional que responde con una lectura breve de 3 cartas,solo usando arcanos mayores.
    CONTENT
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
      IMPORTANTE : no repitas lecturas.
      IMPORTANTE : los nombres permitidos a utilizarse para las cartas deben ser alguno de estos [
    #{ALLOWED_CARD_NAMES.map { |name| "\"#{name}\"" }.join(",\n") }
    ]

    CONTENT
  end
end
