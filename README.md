# Alphasights::Email::Predictor

## Usage

Requires Ruby 2.2.0+

TODO: Write usage instructions here

## Design

1. Parsing provided pattern definitions, to create signature based rules
   for applying against the local-part of an email address.

2. Fetch sample data matching a particular domain. This data can be
   provided via a `Proc` closure, allowing one to fetch the data via an
   ORM, if needed.

3. Subject sample data to the rule set to determine a potential
   naming-scheme.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/alphasights-email-predictor/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
