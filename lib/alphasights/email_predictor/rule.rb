module Alphasights
  module EmailPredictor

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

      def conditions
        @conditions
      end

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

      class BuildExpectation
        pattr_initialize :separators, :observation

        class << self
          def from_pattern(pattern)
            example = pattern[:example]
            separators = pattern[:separators]

            signature = example.keys.first.to_s
            sample = example.values.first

            signature_local_parts = []
            sample_local_parts = []
            separator_chars = []

            separators.each do |k,v|
              separator_chars << v
              signature_local_parts << signature.split("_#{k}_")
              sample_local_parts<< extract_local_from_domain(sample).split(v)
            end
            signature_local_parts.flatten!
            sample_local_parts.flatten!

            observation = { signature_local_parts.map(&:to_sym) => sample_local_parts }

            # NOTE: Example `BuildExpectation` object
            # <Alphasights::EmailPredictor::Rule::BuildExpectation:0x007fba7d804140
            #   @observation={[:first_name, :last_name]=>["john", "ferguson"]},
            #   @separators=["."]>
            expectation = BuildExpectation.new(separator_chars, observation)
            expectation.build_rule(signature)
          end

          private
          def extract_local_from_domain(sample)
            sample.split('@').first
          end
        end

        def build_rule(signature)
          first_key, last_key = @observation.keys.first
          locals_first, locals_last = @observation.values.first

          rule_set = []
          rule_set << if locals_first.length > 1
                        { first_key => Regexp.new(/[\w]+/) }
                      else
                        { first_key => Regexp.new(/[\w]/) }
                      end
          rule_set << if locals_last.length > 1
                        { last_key => Regexp.new(/[\w]+/) }
                      else
                        { last_key => Regexp.new(/[\w]/) }
                      end

          Rule.new(signature.to_sym, @separators, rule_set)
        end
      end
    end

  end
end
