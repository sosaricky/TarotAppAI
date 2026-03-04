class LlmOutputNormalizer
  def self.parse_output(output)
    data_matched = output.match(/(?<json>{.*})/m)
    data_matched ? data_matched[:json].strip : output
  end
end
