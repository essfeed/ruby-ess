require 'ess'
require 'ess/parser'

# Using the validation service for running tests
ESS::Pusher.aggregators = ["http://api.hypecal.com/v1/ess/validator.json"]

