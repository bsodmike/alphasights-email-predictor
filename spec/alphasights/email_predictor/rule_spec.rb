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
        expect(subject.conditions).to eq([{:first_initial=>/[\w]/}, {:last_initial=>/[\w]/}])
      end


    end
  end

end

describe Alphasights::EmailPredictor::Rule do
  let(:predictor) { Alphasights::EmailPredictor }

  before(:each) do
    SpecRunner.run
  end

  describe '::build' do
    it 'should build rules based on patterns provided during configuration' do
      result = described_class.build
      expect(result.collect(&:class).uniq.size).to eq(1)
      expect(result.collect(&:class).uniq.first).to eq(described_class)
    end
  end
end
