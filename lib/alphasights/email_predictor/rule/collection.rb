module Alphasights
  module EmailPredictor
    class Rule

      class Collection
        def initialize
          @rules = []
        end

        def add(rule)
          @rules << rule
        end

        def all
          @rules
        end
      end

    end
  end
end
