class SearchRunner
  ENGINE_CONFIG = {
    "demo" => {
      extractor: Extractors::DuckDuckGoHttpExtractor,
      parser: Parsers::DuckDuckGoParser
    },
    "browser_demo" => {
      extractor: Extractors::FerrumBrowserExtractor,
      parser: Parsers::DuckDuckGoParser
    }
  }.freeze

  def initialize(request)
    @request = request
  end

  def call
    config = ENGINE_CONFIG.fetch(request.engine)
    html = config.fetch(:extractor).new.fetch(query: request.normalized_query, page: request.page)
    parser_result = config.fetch(:parser).new.parse(html)

    {
      search_metadata: {
        engine: request.engine,
        source: "duckduckgo_html",
        fetched_at: Time.current.iso8601
      },
      search_parameters: {
        q: request.normalized_query,
        page: request.page
      },
      organic_results: parser_result.fetch(:organic_results),
      pagination: parser_result.fetch(:pagination)
    }
  end

  private

  attr_reader :request
end
