class CodeSnippetParser
  def self.parse_snippet(snippet)
    data_matched = snippet.match(/(?<json>{.*})/m)
    data_matched ? data_matched[:json].strip : snippet
  end
end
