# frozen_string_literal: true

require "httparty"

module Adapters
  class DeepSeekAdapter
    class ApiError < StandardError; end

    API_ENDPOINT = "https://api.deepseek.com/chat/completions"
    REQUEST_TIMEOUT_SECONDS = 30

    def message_to_chat_api(request_messages)
      response = HTTParty.post(
        API_ENDPOINT,
        headers: headers,
        body: body(request_messages),
        timeout: REQUEST_TIMEOUT_SECONDS
      )

      unless response.success?
        raise ApiError, "DeepSeek API responded with status #{response.code}"
      end

      response.body
    rescue Timeout::Error, SocketError, HTTParty::Error, SystemCallError => e
      raise ApiError, "DeepSeek API request failed: #{e.message}"
    end

    private

    def headers
      {
        "Authorization" => "Bearer #{ENV.fetch('DEEPSEEK_API_KEY')}",
        "Content-Type" => "application/json"
      }
    end

    def body(request_messages)
      {
        model: ENV.fetch("DEEPSEEK_MODEL"),
        messages: request_messages,
        temperature: ENV.fetch("DEEPSEEK_TEMPERATURE").to_f
      }.to_json
    end
  end
end
