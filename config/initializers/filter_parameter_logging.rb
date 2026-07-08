Rails.application.config.filter_parameters += %i[
  authorization
  password
  secret
  token
]
