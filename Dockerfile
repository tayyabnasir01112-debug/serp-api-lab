FROM ruby:3.3.6-slim AS base

ENV BUNDLE_PATH=/usr/local/bundle \
    RAILS_ENV=production

WORKDIR /app
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    chromium \
    curl \
    git \
    libpq-dev \
    pkg-config \
  && rm -rf /var/lib/apt/lists/*

COPY Gemfile ./
RUN bundle install

COPY . .
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=5s --retries=3 CMD curl -fsS http://localhost:3000/health || exit 1
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
