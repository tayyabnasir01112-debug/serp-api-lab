class SearchRequest
  include ActiveModel::Model

  SUPPORTED_ENGINES = %w[demo browser_demo].freeze

  attr_reader :q, :engine, :page

  validates :q, presence: true, length: { maximum: 240 }
  validates :engine, inclusion: { in: SUPPORTED_ENGINES }
  validates :page, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 20 }

  def initialize(attributes = {})
    super()
    @q = attributes.fetch("q", attributes[:q]).to_s.strip
    @engine = attributes.fetch("engine", attributes[:engine] || "demo").to_s
    @page = attributes.fetch("page", attributes[:page] || 1).to_i
  end

  def normalized_query
    q.squeeze(" ")
  end
end
