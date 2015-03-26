require 'spec_helper'

describe Alphasights::EmailPredictor do
  it 'has a version number' do
    expect(Alphasights::EmailPredictor::VERSION).not_to be nil
  end

  it 'is a module' do
    expect(described_class).to be_a(Module)
  end
end
