# frozen_string_literal: true

require "httparty"
module Adapters
  class DeepSeekAdapter
    def message_to_chat_api(request_messages)
      headers = {
        "Authorization" => "Bearer #{ENV.fetch('DEEPSEEK_API_KEY')}",
        "Content-Type" => "application/json"
      }
      body = {
        model: ENV.fetch("DEEPSEEK_MODEL"),
        messages: request_messages,
        temperature: ENV.fetch("DEEPSEEK_TEMPERATURE").to_f
      }.to_json

      HTTParty.post(
        "https://api.deepseek.com/chat/completions",
        headers:,
        body:
      ).body
    end
  end
end
