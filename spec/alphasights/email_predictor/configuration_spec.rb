require 'spec_helper'

describe Alphasights::EmailPredictor::Configuration do

  let(:predictor) { Alphasights::EmailPredictor }

  describe 'predictor::fetch_advisors' do
    context 'when advisors has not been set, or is not a closure' do
      it 'should raise an exception' do
        expect(predictor::Configuration).to receive(:advisors).once { [] }

        expect { predictor::fetch_advisors }.to raise_exception(predictor::Error::Base)
      end
    end

    context 'with advisors provided as a closure' do

      it 'should expect advisors to be provided as a `Hash`' do
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

        expect(predictor::fetch_advisors).to be_a(Hash)
        expect(predictor::fetch_advisors.keys.first).to eq('John Ferguson')
      end
    end
  end

end

