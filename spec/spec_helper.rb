require 'simplecov'
SimpleCov.coverage_dir('target/coverage')
SimpleCov.start

require 'evaluator'

RSpec.configure do |config|
  config.order = :random
  config.color = true
end
