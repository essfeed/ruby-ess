require 'ess'

# Using the validation service for running tests
ESS::Pusher.aggregators = ["http://api.hypecal.com/v1/ess/validator.json"]

