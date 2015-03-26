module Alphasights
  module EmailPredictor

    require_relative 'rule/collection'
    require_relative 'rule/build_expectation'

    class Rule

      def initialize(signature, separators, conditions)
        @signature = signature
        @separators = separators
        @conditions = conditions
      end

      def self.build
        Configuration.patterns.each do |pattern|
          collection.add BuildExpectation.from_pattern(pattern)
        end
        collection.all
      end

      def self.all
        collection.all
      end

      def self.collection
        @collection ||= Collection.new
      end

      def signature
        @signature
      end

      def conditions
        @conditions
      end

    end

  end
end
