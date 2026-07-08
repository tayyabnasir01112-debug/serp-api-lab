require "cgi"
require "nokogiri"

module Parsers
  class DuckDuckGoParser
    def parse(html)
      doc = Nokogiri::HTML(html)
      results = doc.css(".result").each_with_index.filter_map do |node, index|
        title_node = node.at_css(".result__title a")
        next if title_node.nil?

        {
          position: index + 1,
          title: clean(title_node.text),
          link: normalized_link(title_node["href"]),
          snippet: clean(node.at_css(".result__snippet")&.text),
          displayed_link: clean(node.at_css(".result__url")&.text)
        }
      end

      {
        organic_results: results,
        pagination: {
          result_count: results.length,
          has_more: !doc.css("input[name='s'], .nav-link").empty?
        }
      }
    end

    private

    def clean(value)
      value.to_s.gsub(/\s+/, " ").strip
    end

    def normalized_link(value)
      raw = value.to_s
      return raw if raw.empty?

      uri = URI.parse(raw)
      params = CGI.parse(uri.query.to_s)
      params.fetch("uddg", [raw]).first
    rescue URI::InvalidURIError
      raw
    end
  end
end
