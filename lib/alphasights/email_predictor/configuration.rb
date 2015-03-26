module Alphasights
  module EmailPredictor
    module Configuration
      extend self
      attr_accessor :patterns,
        :advisors

      self.patterns = []
      self.advisors = nil
      # or alternatively,
      #   self.advisors = proc {
      #     ::Advisors.active.to_hash
      #   }
      #
    end
  end
end
