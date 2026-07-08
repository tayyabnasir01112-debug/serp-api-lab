require "rails_helper"

RSpec.describe Parsers::DuckDuckGoParser do
  it "normalizes organic search results" do
    html = Rails.root.join("spec/fixtures/files/duckduckgo.html").read

    result = described_class.new.parse(html)

    expect(result.fetch(:organic_results)).to contain_exactly(
      include(position: 1, title: "Python Jobs", link: "https://www.python.org/jobs/"),
      include(position: 2, title: "Python Careers", link: "https://example.com/python-careers")
    )
    expect(result.fetch(:pagination)).to include(result_count: 2, has_more: true)
  end
end
