require 'spec_helper'

module SpecRunner
  extend self

  def run
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
    end

  end
end

describe Alphasights::EmailPredictor::Rule::BuildExpectation do
  let(:predictor) { Alphasights::EmailPredictor }

  before(:each) do
    SpecRunner.run
  end

  context 'when given a single pattern' do
    describe '#from_pattern' do
      let(:pattern) { predictor::Configuration.patterns.last }
      let(:subject) { described_class.from_pattern pattern }

      it 'should process the given pattern, into a rule' do
        expect(subject).to be_a(Alphasights::EmailPredictor::Rule)
      end

      it 'should process given patten into following conditions' do
        expect(subject.conditions).to eq([{:first_initial=>/([\w])/}, {:last_initial=>/([\w])/}])
      end

      context 'when provided an alternative signature format' do
        let(:pattern) {
          {
            example: { first_name_dash_last_name: "john-ferguson@alphasights.com" },
            separators: { "dash" => '-' }
          }
        }
        let(:subject) { described_class.from_pattern pattern }

        it 'should not raise exception' do
          expect { subject }.not_to raise_exception
        end

        it 'should return a rule for the alternative format' do
          expect(subject.signature).to eq(:first_name_dash_last_name)
        end
      end

      context 'when provided an invalid sample' do
        let(:error_klass) { Alphasights::EmailPredictor::Error }
        let(:pattern) {
          {
            example: { first_name_dash_last_name: "john.ferguson@alphasights.com" },
            separators: { "dash" => '-' }
          }
        }
        let(:subject) { described_class.from_pattern pattern }

        it 'should raise an exception' do
          expect { subject }.to raise_exception(error_klass::UnknownPatternError, /check provided separator/)
        end
      end
    end
  end

end

describe Alphasights::EmailPredictor::Rule do
  let(:predictor) { Alphasights::EmailPredictor }
  let(:result) {
    # NOTE hacking in, to clear rules within the collection instance, to
    # prevent pollution from calls to `described_class.build` from other specs
    #
    # Intentionally accessing the instance variable directly, rather than
    # exposing it via the `Collection` class' API.
    described_class.collection.instance_variable_set('@rules', [])
    described_class.build
  }

  before(:each) do
    SpecRunner.run
  end

  describe '::build' do
    it 'should build rules based on patterns provided during configuration' do
      expect(result.size).to eq(predictor::Configuration.patterns.size)
    end

    it 'should return a collection of class `Alphasights::EmailPredictor::Rule`' do
      expect(result.collect(&:class).uniq.size).to eq(1)
      expect(result.collect(&:class).uniq.first).to eq(described_class)
    end
  end
end
