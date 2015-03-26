require 'alphasights/email_predictor/version'
require 'pry'

module Alphasights
  module EmailPredictor
    require 'attr_extras'
    require 'alphasights/email_predictor/configuration'

    module Error
      class Base < StandardError; end
      class UnknownPatternError < Base; end
    end

    autoload :Rule,     'alphasights/email_predictor/rule'

    def self.setup
      yield(Configuration)
    end
  end
end
