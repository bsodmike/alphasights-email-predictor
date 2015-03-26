module Alphasights
  module EmailPredictor

    class Predictor

      def call(full_name, domain)
        patterns = FindPattern.new.process(domain.downcase)
        first_name, last_name = full_name.downcase.split(' ')
        patterns

        message = "Unable to predict an email address for advisor '#{full_name}' with domain '#{domain}'"
        return message if patterns.empty?

        rules = []
        patterns.each do |pattern|
          rules << find_rule_by(pattern)
        end

        separators = rules.map(&:separators).flatten
        rule = rules.sample(1).first

        conditions = rule.conditions
        matched = {}
        [first_name, last_name].each_with_index do |obj, i|
          obj.match(conditions[i].values.first)
          matched[conditions[i].keys.first] = $~.to_s if $~
        end

        "#{matched.values.join(separators.first)}@#{domain}"
      end

      private
      def find_rule_by(signature)
        EmailPredictor::Rule.all.reject do |e|
          e.signature != signature
        end.first
      end

    end

  end
end
