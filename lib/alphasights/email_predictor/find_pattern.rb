module Alphasights
  module EmailPredictor

    class FindPattern

      def initialize
        @advisors = EmailPredictor.fetch_advisors
        @rules = EmailPredictor::Rule.build
      end

      attr_reader :advisors

      def advisors_for(domain)
        l = []
        advisors.each do |name, email|
          l << { name => email } if domain == domain_from(email)
        end
        l
      end

      def process(domain)
        _advisors = advisors_for(domain.downcase)

        results = []
        _advisors.each do |advisor_hsh|
          results << apply_rules_to(@rules, advisor_hsh)
        end

        patterns = []
        results.each do |e|
          patterns << e[0]
        end
        patterns.uniq
      end

      def apply_rules_to(rules, hash)
        match = nil
        rules.each do |rule|
          result = apply_rule_to(rule, hash)
          match = result if result
        end

        [match, hash]
      end

      # @return [Hash]
      def apply_rule_to(rule, hash)
        name = hash.keys.first
        first_name, last_name = name.split(' ')
        email_local = hash.values.first.split('@').first

        separators = rule.separators
        local_parts =  []
        separators.each do |char|
          local_parts << email_local.split(char)
        end
        local_parts.flatten!

        conditions = rule.conditions
        matched = {}
        local_parts.each_with_index do |obj, i|
          obj.match(conditions[i].values.first)
          matched[conditions[i].keys.first] = $~.to_s if $~
        end

        return unless matched.size > 1
        return unless matched.values == local_parts
        rule.signature
      end

      private
      def domain_from(email)
        email.split('@').last
      end

    end

  end
end
