class ApplicationJob < ActiveJob::Base
  retry_on Extractors::FetchError, wait: :polynomially_longer, attempts: 3
end
