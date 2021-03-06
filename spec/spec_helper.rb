require 'simplecov'
require 'coveralls'
require 'pry'

SimpleCov.formatters = [SimpleCov::Formatter::HTMLFormatter, Coveralls::SimpleCov::Formatter]

SimpleCov.start

require 'isic'

RSpec.configure do |config|

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

end