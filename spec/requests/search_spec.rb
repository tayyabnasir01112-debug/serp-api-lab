require "rails_helper"

RSpec.describe "Search API" do
  it "returns normalized search results and persists a request log" do
    response_body = {
      search_metadata: { engine: "demo", source: "test", fetched_at: Time.current.iso8601 },
      search_parameters: { q: "python jobs", page: 1 },
      organic_results: [{ position: 1, title: "Python Jobs", link: "https://python.org/jobs" }],
      pagination: { result_count: 1, has_more: false }
    }
    runner = instance_double(SearchRunner, call: response_body)
    allow(SearchRunner).to receive(:new).and_return(runner)

    get "/search", params: { q: "python jobs", engine: "demo", page: 1 }

    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body)).to include("request_id", "duration_ms")
    expect(RequestLog.last).to have_attributes(query: "python jobs", engine: "demo", status: "succeeded")
  end

  it "rejects invalid request parameters" do
    get "/search", params: { q: "", engine: "not-real" }

    expect(response).to have_http_status(:unprocessable_entity)
    expect(JSON.parse(response.body).fetch("error")).to eq("validation_error")
  end
end
