require "rails_helper"

RSpec.describe SearchRequest do
  it "normalizes queries and applies default engine/page" do
    request = described_class.new("q" => "  ruby   scraping  ")

    expect(request).to be_valid
    expect(request.normalized_query).to eq("ruby scraping")
    expect(request.engine).to eq("demo")
    expect(request.page).to eq(1)
  end

  it "rejects unsupported engines" do
    request = described_class.new("q" => "ruby", "engine" => "unknown")

    expect(request).not_to be_valid
    expect(request.errors[:engine]).to be_present
  end
end
