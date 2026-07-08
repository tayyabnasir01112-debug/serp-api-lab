class RequestLog < ApplicationRecord
  enum :status, { succeeded: 0, failed: 1 }

  validates :query, :engine, :page, :status, presence: true
end
