require "cgi"
require "uri"

module Extractors
  class DuckDuckGoHttpExtractor
    ENDPOINT = "https://html.duckduckgo.com/html/".freeze

    def initialize(client: StaticHttpClient.new)
      @client = client
    end

    def fetch(query:, page:)
      uri = URI(ENDPOINT)
      offset = [(page.to_i - 1) * 30, 0].max
      uri.query = URI.encode_www_form(q: query, s: offset)
      client.get(uri)
    end

    private

    attr_reader :client
  end
end
