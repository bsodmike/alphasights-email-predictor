$LOAD_PATH.unshift File.expand_path('../lib/', __FILE__)
require 'alphasights/email_predictor'

::Alphasights::EmailPredictor.setup do |config|
  config.patterns = [
    {
      example: { first_name_dot_last_name: "john.ferguson@alphasights.com" },
      separators: { "dot" => '.' }
    },
    {
      example: { first_name_dot_last_initial: "john.f@alphasights.com" },
      separators: { "dot" => '.' }
    },
    {
      example: { first_initial_dot_last_name: "j.ferguson@alphasights.com" },
      separators: { "dot" => '.' }
    },
    {
      example: { first_initial_dot_last_initial: "j.f@alphasights.com" },
      separators: { "dot" => '.' }
    }
  ]

  config.advisors = proc {
    {
      "John Ferguson" => "john.ferguson@alphasights.com",
      "Damon Aw" => "damon.aw@alphasights.com",
      "Linda Li" => "linda.li@alphasights.com",
      "Larry Page" => "larry.p@google.com",
      "Sergey Brin" => "s.brin@google.com",
      "Steve Jobs" => "s.j@apple.com"
    }
  }
end

examples = {
  "Peter Wong" => "alphasights.com",
  "Craig Silverstein" => "google.com",
  "Steve Wozniak" => "apple.com",
  "Barack Obama" => "whitehouse.gov"
}

l = ""
examples.each do |name, domain|
  predicted_email = Alphasights::EmailPredictor.predict(name, domain)
  l << "#{name}: #{predicted_email}\n"
end

puts l

__END__

# Example output from concecutive runs

-> % ruby run.rb
Peter Wong: peter.wong@alphasights.com
Craig Silverstein: c.silverstein@google.com
Steve Wozniak: s.w@apple.com
Barack Obama: Unable to predict an email address for advisor 'Barack Obama' with domain 'whitehouse.gov'

-> % ruby run.rb
Peter Wong: peter.wong@alphasights.com
Craig Silverstein: craig.s@google.com
Steve Wozniak: s.w@apple.com
Barack Obama: Unable to predict an email address for advisor 'Barack Obama' with domain 'whitehouse.gov'
