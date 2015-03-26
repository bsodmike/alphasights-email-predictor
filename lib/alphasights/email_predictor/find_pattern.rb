module Alphasights
  module EmailPredictor

    class FindPattern

      pattr_initialize :advisors

      def advisors_for(domain)
        l = []
        advisors.each do |name, email|
          l << { name => email } if domain == domain_from(email)
        end
        l
      end

      private
      def domain_from(email)
        email.split('@').last
      end

    end

  end
end
