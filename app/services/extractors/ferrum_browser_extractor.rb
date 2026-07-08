require "ferrum"
require "uri"

module Extractors
  class FerrumBrowserExtractor
    ENDPOINT = "https://html.duckduckgo.com/html/".freeze

    def fetch(query:, page:)
      browser = Ferrum::Browser.new(
        browser_options: { "no-sandbox": nil },
        timeout: ENV.fetch("BROWSER_TIMEOUT_SECONDS", 15).to_i
      )
      uri = URI(ENDPOINT)
      uri.query = URI.encode_www_form(q: query, s: [(page.to_i - 1) * 30, 0].max)
      browser.goto(uri.to_s)
      browser.body
    rescue Ferrum::Error => e
      raise FetchError, e.message
    ensure
      browser&.quit
    end
  end
end
