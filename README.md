# Alphasights::Email::Predictor

## Usage

Requires Ruby 2.2.0+.  Run the examples via `bundle install && ruby run.rb`, to predict emails for the test payload.
Specs may be run via `rspec` or `guard`, which will monitor files for
any changes and re-run the spec suite.

## Design Approach

1. Parsing provided pattern definitions, to create signature based rules
   for applying against the local-part of an email address.

2. Fetch sample data matching a particular domain. This data can be
   provided via a `Proc` closure, allowing one to fetch the data via an
   ORM, if needed.

3. Subject sample data to the rule set to determine a potential
   naming-scheme.

## Results

### Stories

```
-> % rspec
Run options: include {:focus=>true}

All examples were filtered out; ignoring {:focus=>true}

Randomized with seed 30079

Alphasights::EmailPredictor::FindPattern

    #apply_rule_to
      when an incompatible rule is applied
        should return `nil`
      when a compatible rule is applied
        should return the rule's signature
    #apply_rules_to
      when provided an email incompatible  with the built rules
        should return `nil` as the signature
      when provided an email compatible with the built rules
        should determine the naming pattern correctly
    #process
      should determine the naming pattern correctly
      when given a different domain
        should determine the naming pattern correctly, even if the domain contains capitalised letters
        should determine the naming pattern correctly
  #advisors_for
    should fetch advisors for the provided domain
    when given a domain not within the advisor dataset
      should return an empty set

Alphasights::EmailPredictor
  is a module
  has a version number

Alphasights::EmailPredictor::Rule
  ::build
    should return a collection of class `Alphasights::EmailPredictor::Rule`
    should build rules based on patterns provided during configuration

Alphasights::EmailPredictor::Rule::BuildExpectation
  when given a single pattern
    #from_pattern
      should process given patten into following conditions
      should process the given pattern, into a rule
      when provided an invalid sample
        should raise an exception
      when provided an alternative signature format
        should return a rule for the alternative format
        should not raise exception

Alphasights::EmailPredictor::Predictor
  #call
    should predict an email address
    when given a domain not-present in the sample dataset
      should present a suitable error message

Alphasights::EmailPredictor::Configuration
  predictor::fetch_advisors
    with advisors provided as a closure
      should expect advisors to be provided as a `Hash`
    when advisors has not been set, or is not a closure
      should raise an exception

Finished in 0.01495 seconds (files took 0.2058 seconds to load)
22 examples, 0 failures
```

### Predictions for Test Data

```
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
```

## License

This project rocks and uses MIT-LICENSE.
