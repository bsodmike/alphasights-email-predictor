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

      # NOTE Example set of parsed rules
      #
      # [#<Alphasights::EmailPredictor::Rule:0x007f8382c78118
      #   @conditions=[{:first_name=>/[\w]+/}, {:last_name=>/[\w]+/}],
      #   @separators=["."],
      #   @signature=:first_name_dot_last_name>,
      #  #<Alphasights::EmailPredictor::Rule:0x007f83840c7ce0
      #   @conditions=[{:first_name=>/[\w]+/}, {:last_initial=>/[\w]/}],
      #   @separators=["."],
      #   @signature=:first_name_dot_last_initial>,
      #  #<Alphasights::EmailPredictor::Rule:0x007f83840c7538
      #   @conditions=[{:first_initial=>/[\w]/}, {:last_name=>/[\w]+/}],
      #   @separators=["."],
      #   @signature=:first_initial_dot_last_name>,
      #  #<Alphasights::EmailPredictor::Rule:0x007f83840c6db8
      #   @conditions=[{:first_initial=>/[\w]/}, {:last_initial=>/[\w]/}],
      #   @separators=["."],
      #   @signature=:first_initial_dot_last_initial>]
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
