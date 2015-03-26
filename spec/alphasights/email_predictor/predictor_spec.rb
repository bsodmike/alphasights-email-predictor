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

describe Alphasights::EmailPredictor::Predictor do

  let(:subject) { described_class.new}
  let(:predictor) { Alphasights::EmailPredictor }
  let(:domain) { 'google.com' }

  before(:each) do
    SpecRunner.run

    # NOTE this is to prevent spec breakage when running the entire suite
    expect(predictor::Configuration).to receive(:advisors).at_least(:once) {
      proc {
        {
          "John Ferguson" => "john.ferguson@alphasights.com",
          "Damon Aw" => "damon.aw@alphasights.com",
          "Linda Li" => "linda.li@alphasights.com",
          "Larry Page" => "larry.p@google.com",
          "Sergey Brin" => "s.brin@google.com",
          "Steve Jobs" => "s.j@apple.com"
        }
      }
    }
  end

  describe '#call' do
    it 'should predict an email address' do
      expect(%w(c.silverstein@google.com craig.s@google.com)).to include(subject.call("Craig Silverstein", "google.com"))
    end

    context 'when given a domain not-present in the sample dataset' do
      it 'should present a suitable error message' do
        expect(subject.call("Peter Wong", "nbc.com")).to match(/Unable to predict an email address/)
      end
    end
  end

end



