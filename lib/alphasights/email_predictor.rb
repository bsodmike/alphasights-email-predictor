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

    autoload :FindPattern,  'alphasights/email_predictor/find_pattern'
    autoload :Predictor,    'alphasights/email_predictor/predictor'
    autoload :Rule,         'alphasights/email_predictor/rule'

    class << self
      def setup
        yield(Configuration)
      end

      def fetch_advisors
        o = Configuration.advisors
        raise Error::Base.new('Advisors need to be provided via a closure, returning a hash of advisor names and email addresses') unless o.is_a?(Proc)

        o.call
      end

      def predict(name, domain)
        Predictor.new.
          call(name, domain)
      end
    end

  end
end
