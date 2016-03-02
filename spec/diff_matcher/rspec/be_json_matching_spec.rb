require 'spec_helper'
require 'diff_matcher/rspec'

require 'delegate'

describe DiffMatcher::RSpec::BeJsonMatching do
  subject { described_class.new(expected).with_options(:color_enabled => false) }
  let(:expected) { {'a' => 1, 'b' => [2]} }
  let(:right)    { JSON.dump(expected) }
  let(:wrong)    { JSON.dump({:a => 21, :b => []}) }

  context 'actual matches', focus: true do
    describe '#matches?' do
      it { expect(subject.matches?(right)).to be_truthy }
    end
  end

  context 'actaul not matches' do
    describe '#matches?' do
      it { expect(subject.matches?(wrong)).to be_falsey }
    end
  end

  context "JSON can't be parsed" do
    let(:wrong) { "I am unparsable JSON" }

    it 'not matches' do
      expect(subject.matches?(wrong)).to be_falsey
    end

    it 'shows relevant error' do
      subject.matches?(wrong)
      expect(subject.failure_message).to eq "error parsing JSON: 757: unexpected token at 'I am unparsable JSON'"
    end
  end
end
