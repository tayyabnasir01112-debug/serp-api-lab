module RateLimits
  class FixedWindow
    Entry = Struct.new(:count, :reset_at, keyword_init: true)

    @store = {}
    @mutex = Mutex.new

    class << self
      attr_reader :store, :mutex
    end

    def initialize(key:, limit:, window_seconds:)
      @key = key
      @limit = limit
      @window_seconds = window_seconds
    end

    def allowed?
      self.class.mutex.synchronize do
        entry = current_entry
        entry.count += 1
        entry.count <= limit
      end
    end

    private

    attr_reader :key, :limit, :window_seconds

    def current_entry
      now = Time.current
      entry = self.class.store[key]
      if entry.nil? || entry.reset_at <= now
        entry = Entry.new(count: 0, reset_at: now + window_seconds)
        self.class.store[key] = entry
      end
      entry
    end
  end
end
