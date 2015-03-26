$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'alphasights/email_predictor'
require 'mocha/api'

RSpec.configure do |config|
  config.mock_with :mocha
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'

  # Disable should syntax
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
