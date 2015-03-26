require 'spec_helper'

module SpecRunner
  extend self

  def run
    ::Alphasights::EmailPredictor.setup do |config|
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

  end
end

describe Alphasights::EmailPredictor::FindPattern do

  let(:predictor) { Alphasights::EmailPredictor }

  before(:each) do
    SpecRunner.run
  end

  describe '#advisors_for' do
    let(:subject) { described_class.new(predictor::fetch_advisors) }
    let(:domain) { 'google.com' }

    it 'should fetch advisors for the provided domain' do
      expect(subject.advisors_for(domain)).to eq([{"Larry Page"=>"larry.p@google.com"}, {"Sergey Brin"=>"s.brin@google.com"}])
    end

    context 'when given a domain not within the advisor dataset' do
      it 'should return an empty set' do
        expect(subject.advisors_for('inertialbox.com')).to eq(Array.new)
      end
    end

  end

end

