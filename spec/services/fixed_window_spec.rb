require "rails_helper"

RSpec.describe RateLimits::FixedWindow do
  it "allows requests until the configured window budget is exhausted" do
    limiter = described_class.new(key: "client-1", limit: 2, window_seconds: 60)

    expect(limiter.allowed?).to be(true)
    expect(limiter.allowed?).to be(true)
    expect(limiter.allowed?).to be(false)
  end
end
