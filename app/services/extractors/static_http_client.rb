require "net/http"
require "uri"

module Extractors
  class StaticHttpClient
    USER_AGENT = "serp-api-lab/0.1 portfolio search crawler".freeze

    def initialize(retries: 2, timeout_seconds: 10)
      @retries = retries
      @timeout_seconds = timeout_seconds
    end

    def get(uri)
      attempts = 0

      begin
        attempts += 1
        response = request(uri)
        return response.body if response.is_a?(Net::HTTPSuccess)

        raise FetchError, "HTTP #{response.code} from #{uri.host}"
      rescue StandardError => e
        raise FetchError, e.message if attempts > retries

        sleep(0.25 * attempts)
        retry
      end
    end

    private

    attr_reader :retries, :timeout_seconds

    def request(uri)
      Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https") do |http|
        http.open_timeout = timeout_seconds
        http.read_timeout = timeout_seconds
        request = Net::HTTP::Get.new(uri)
        request["User-Agent"] = USER_AGENT
        request["Accept"] = "text/html,application/xhtml+xml"
        http.request(request)
      end
    end
  end
end
