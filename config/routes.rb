require "sidekiq/web"

Rails.application.routes.draw do
  get "/health", to: "health#show"
  get "/search", to: "search#show"
  mount Sidekiq::Web => "/sidekiq" if Rails.env.development?
end
