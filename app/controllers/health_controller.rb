class HealthController < ApplicationController
  def show
    RequestLog.limit(1).pluck(:id)
    render json: {
      service: "serp-api-lab",
      status: "ok",
      database: "ok",
      ruby: RUBY_VERSION
    }
  end
end
