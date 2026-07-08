class ApplicationController < ActionController::API
  rescue_from ActionController::ParameterMissing, with: :bad_request

  private

  def bad_request(error)
    render json: { error: "bad_request", message: error.message }, status: :bad_request
  end
end
