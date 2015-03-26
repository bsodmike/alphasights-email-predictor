require 'alphasights/email_predictor/version'
require 'pry'

module Alphasights
  module EmailPredictor
    require 'attr_extras'
    require 'alphasights/email_predictor/configuration'

    autoload :Rule,     'alphasights/email_predictor/rule'

    def self.setup
      yield(Configuration)
    end
  end
end
