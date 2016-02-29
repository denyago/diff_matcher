require 'spec_helper'
require 'diff_matcher/rspec'

describe DiffMatcher::RSpec::BeMatching do
  subject { described_class.new(expected).with_options(:color_enabled => false) }
  let(:expected) { {:a => 1, :b => [2]} }
  let(:right)    { expected }
  let(:wrong)    { {:a => 21, :b => []} }

  context 'actual matches' do
    describe '#matches?' do
      it { expect(subject.matches?(right)).to be_truthy }
    end
    let(:error_message) { "diff is:\n{\n  :a=>1,\n  :b=>[\n    2\n  ]\n}" }

    describe '#failure_message' do
      it 'returns empty diff' do
        subject.matches?(right)
        expect(subject.failure_message).to eq error_message
      end
    end

    describe '#failure_message_when_negated' do
      it 'returns empty diff' do
        subject.matches?(right)
        expect(subject.failure_message).to eq error_message
      end
    end
  end

  context 'actaul not matches' do
    describe '#matches?' do
      it { expect(subject.matches?(wrong)).to be_falsey }
    end
    let(:error_message) { "diff is:\n{\n  :a=>- 1+ 21,\n  :b=>[\n  - 2\n  ]\n}\nWhere, - 2 missing, + 1 additional" }

    describe '#failure_message' do
      it 'returns diff' do
        subject.matches?(wrong)
        expect(subject.failure_message).to eq error_message
      end
    end

    describe '#failure_message_when_negated' do
      it 'returns diff' do
        subject.matches?(wrong)
        expect(subject.failure_message).to eq error_message
      end
    end
  end

  describe 'option "normalized"' do
    subject { described_class.new(expected).normalized }

    let(:hash_with_symbolization) do
      Class.new(SimpleDelegator) do
        def deep_symbolize_keys
          __getobj__.inject({}) {|memo, (k,v)| memo.merge({k.to_sym => v})}
        end
      end
    end

    context  'Hashes with Strings and Symbols as keys' do
      let(:expected) { hash_with_symbolization.new(:id => 1) }
      let(:right)    { hash_with_symbolization.new('id' => 1) }

      it 'matched' do
        expect(subject.matches?(right)).to be_truthy
      end

      context 'withing Array' do
        let(:expected) do
          [hash_with_symbolization.new(:id => 1), hash_with_symbolization.new(:id => 2)]
        end
        let(:right) do
          [hash_with_symbolization.new('id' => 1), hash_with_symbolization.new('id' => 2)]
        end

        it 'matched' do
          expect(subject.matches?(right)).to be_truthy
        end
      end
    end
  end

  describe 'ordered' do
    subject { described_class.new(expected).ordered('_id') }

    let(:expected) { [{:_id => 1}, {:_id => 2}] }
    let(:right)    { [{:_id => 2}, {:_id => 1}] }

    it 'matches arrays in any order' do
      expect(subject.matches?(right)).to be_truthy
    end

    context 'with Regexp' do
      subject { described_class.new(expected).ordered(/_+id/) }

      it 'matches arrays in any order' do
        expect(subject.matches?(right)).to be_truthy
      end
    end
  end
end
