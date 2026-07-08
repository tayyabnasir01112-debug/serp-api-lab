class SerpRefreshJob < ApplicationJob
  queue_as :serp

  def perform(query:, engine: "demo", page: 1)
    request = SearchRequest.new("q" => query, "engine" => engine, "page" => page)
    raise ActiveModel::ValidationError.new(request) unless request.valid?

    response = SearchRunner.new(request).call
    RequestLog.create!(
      query: request.normalized_query,
      engine: request.engine,
      page: request.page,
      status: :succeeded,
      response: response
    )
  end
end
