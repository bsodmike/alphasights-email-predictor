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

describe Alphasights::EmailPredictor::FindPattern do

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

  describe '#advisors_for' do

    it 'should fetch advisors for the provided domain' do
      expect(subject.advisors_for(domain)).to eq([{"Larry Page"=>"larry.p@google.com"}, {"Sergey Brin"=>"s.brin@google.com"}])
    end

    context 'when given a domain not within the advisor dataset' do
      it 'should return an empty set' do
        expect(subject.advisors_for('inertialbox.com')).to eq(Array.new)
      end
    end

  end

  describe do
    before(:each) do
      # NOTE Rather than expanding the API surface of
      # `Alphasights::EmailPredictor::Rule::Collection` any further, the
      # instance variable is accessed and reset directly to prevent rule
      # pollution by repeated calls to `Alphasights::EmailPredictor::Rule::build`
      predictor::Rule.collection.instance_variable_set('@rules', [])
    end

    describe '#process' do
      it 'should determine the naming pattern correctly' do
        expect(subject.process(domain)).to \
          eq([:first_name_dot_last_initial, :first_initial_dot_last_name])
      end

      context 'when given a different domain' do
        it 'should determine the naming pattern correctly' do
          expect(subject.process('apple.com')).to \
            eq([:first_initial_dot_last_initial])
        end

        it 'should determine the naming pattern correctly, even if the domain contains capitalised letters' do
          expect(subject.process('Alphasights.com')).to \
            eq([:first_name_dot_last_name])
        end
      end
    end

    describe '#apply_rules_to' do
      context 'when provided an email compatible with the built rules' do
        it 'should determine the naming pattern correctly' do
          expect(subject.apply_rules_to(subject.instance_variable_get('@rules'),
            {"Sergey Brin"=>"s.brin@google.com"})
          ).to eq([:first_initial_dot_last_name, {"Sergey Brin"=>"s.brin@google.com"}])
        end
      end

      context 'when provided an email incompatible  with the built rules' do
        it 'should return `nil` as the signature' do
          expect(subject.apply_rules_to(subject.instance_variable_get('@rules'),
            {"Sergey Brin"=>"brin@google.com"})
          ).to eq([nil, {"Sergey Brin"=>"brin@google.com"}])
        end
      end
    end


    describe '#apply_rule_to' do
      context 'when a compatible rule is applied' do
        it "should return the rule's signature" do
          rule = subject.instance_variable_get('@rules').reject do |e|
            e.signature != :first_initial_dot_last_name
          end.first
          expect(subject.apply_rule_to(rule,
            {"Sergey Brin"=>"s.brin@google.com"})
          ).to eq(:first_initial_dot_last_name)
        end
      end

      context 'when an incompatible rule is applied' do
        it "should return `nil`" do
          rule = subject.instance_variable_get('@rules').reject do |e|
            e.signature != :first_name_dot_last_name
          end.first
          expect(subject.apply_rule_to(rule,
            {"Sergey Brin"=>"s.brin@google.com"})
          ).to be_nil
        end
      end
    end

  end

end



