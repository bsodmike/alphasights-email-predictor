module Alphasights
  module EmailPredictor
    class Rule

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
              sample_local_parts << extract_local_from_domain(sample).split(v)
            end
            signature_local_parts.flatten!
            sample_local_parts.flatten!

            raise Error::UnknownPatternError, "Unable to split sample, check provided separator" if sample_local_parts.size == 1 && (sample_local_parts.first =~ /\#{v}/).nil?

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
