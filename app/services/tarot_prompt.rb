# Builds the messages sent to the LLM to request a tarot reading.
class TarotPrompt
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
      Usas lenguaje coloquial argentino y vulgar y tenés unos 30 años.
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
    #{Card::MAJOR_ARCANA_NAMES.map { |name| "\"#{name}\"" }.join(",\n") }
    ]

    CONTENT
  end
end
