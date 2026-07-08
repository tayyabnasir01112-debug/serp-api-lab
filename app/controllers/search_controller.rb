class SearchController < ApplicationController
  def show
    contract = SearchRequest.new(search_params.to_h)
    return render_validation_error(contract) unless contract.valid?
    return render_rate_limited unless limiter_for(contract).allowed?

    started_at = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    response = SearchRunner.new(contract).call
    duration_ms = ((Process.clock_gettime(Process::CLOCK_MONOTONIC) - started_at) * 1000).round
    log = persist_log(contract, response, duration_ms)

    render json: response.merge(request_id: log.id, duration_ms:)
  rescue Extractors::FetchError => e
    persist_error(contract, e)
    render json: { error: "upstream_fetch_failed", message: e.message }, status: :bad_gateway
  end

  private

  def search_params
    params.permit(:q, :engine, :page)
  end

  def limiter_for(contract)
    RateLimits::FixedWindow.new(
      key: "search:#{request.remote_ip}:#{contract.engine}",
      limit: ENV.fetch("SEARCH_RATE_LIMIT", 60).to_i,
      window_seconds: 60
    )
  end

  def render_validation_error(contract)
    render(
      json: { error: "validation_error", messages: contract.errors.full_messages },
      status: :unprocessable_entity
    )
  end

  def render_rate_limited
    render(
      json: { error: "rate_limited", message: "Too many search requests for this client." },
      status: :too_many_requests
    )
  end

  def persist_log(contract, response, duration_ms)
    RequestLog.create!(
      query: contract.normalized_query,
      engine: contract.engine,
      page: contract.page,
      status: :succeeded,
      duration_ms:,
      response: response,
      ip_address: request.remote_ip,
      user_agent: request.user_agent
    )
  end

  def persist_error(contract, error)
    RequestLog.create!(
      query: contract.normalized_query,
      engine: contract.engine,
      page: contract.page,
      status: :failed,
      error: "#{error.class}: #{error.message}",
      ip_address: request.remote_ip,
      user_agent: request.user_agent
    )
  end
end
