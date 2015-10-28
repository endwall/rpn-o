require 'spec_helper'
require 'tempfile'

describe Evaluator do
  let(:input_csv) { './spec/fixtures/test.csv' }
  subject { described_class.new input_csv }

  describe '#cell_array' do
    context 'when there are extra spaces in csv file' do

      let(:tokens) { [[["-", "2", "12"], ["*", "3", "a1"]]] }

      it 'should return the right result' do
        expect(subject.send(:cell_array)).to eq(tokens)
      end
    end
  end

  describe '#process_token' do
    let(:cell_array) {
      [[["-", "2", "12"], ["*", "3", "a1"]]]
    }

    context 'when it is a number' do
      let(:tokens) { ["12"] }

      it 'should return 12.0' do
        expect(subject.process_token(tokens)).to eq(12)
      end
    end

    context 'when it is a single operator' do
      let(:tokens) { ["+"] }

      it 'should return #ERR' do
        expect(subject.process_token(tokens)).to eq('#ERR')
      end
    end

    context 'when there is a reference expression' do
      let(:tokens) { ["*", "3", "a1"] }
      let(:cell_array) {
        [[["-", "2", "12"], ["*", "3", "a1"]]]
      }

      it 'should return 30' do
        allow(subject).to receive(:cell_array).and_return(cell_array)
        expect(subject.process_token(tokens)).to eq(30)
      end
    end

    context 'when there is a single reference' do
      let(:tokens) { ["a1"] }
      let(:cell_array) {
        [[["-", "2", "12"], ["*", "3", "a1"], ["a1"]]]
      }

      it 'should return 10' do
        allow(subject).to receive(:cell_array).and_return(cell_array)
        expect(subject.process_token(tokens)).to eq(10)
      end
    end

    context 'when there is a single reference which does not exists' do
      let(:tokens) { ["b2"] }
      let(:cell_array) {
        [[["b2"], ["-", "2", "12"], ["*", "3", "a1"]]]
      }

      it 'should return #ERR' do
        allow(subject).to receive(:cell_array).and_return(cell_array)
        expect(subject.process_token(tokens)).to eq('#ERR')
      end
    end

    context 'when there is a single reference which is not valid' do
      let(:tokens) { ["b"] }
      let(:cell_array) {
        [[["-", "b", "2"], ["-", "2", "12"], ["*", "3", "a1"]]]
      }

      it 'should return #ERR' do
        allow(subject).to receive(:cell_array).and_return(cell_array)
        expect(subject.process_token(tokens)).to eq('#ERR')
      end
    end

    context 'when there is an empty cell' do
      let(:tokens) { [] }
      let(:cell_array) {
        [[["-", "b", "2"], ["-", "2", "12"], []]]
      }

      it 'should return 0' do
        allow(subject).to receive(:cell_array).and_return(cell_array)
        expect(subject.process_token(tokens)).to eq(0)
      end
    end

    context 'when it is divided by 0' do
      let(:tokens) { ["/", "0", "2"] }
      let(:cell_array) {
        [[["/", "0", "2"], ["-", "2", "12"], ["*", "3", "a1"]]]
      }

      it 'should return #ERR' do
        allow(subject).to receive(:cell_array).and_return(cell_array)
        expect(subject.process_token(tokens)).to eq('#ERR')
      end
    end

  end

  describe "#run" do
    context 'when there are multiple cells' do
      let(:cell_array) {
        [[["/", "2", "12"], ["*", "3", "a1"], ["a1"]]]
      }
      let(:result) {
        [[6, 18, 6]]
      }
      it 'should return 3 valid numbers' do
        allow(subject).to receive(:cell_array).and_return(cell_array)
        expect(subject.run).to eq(result)
      end
    end

    context 'when there are multiple cells and error' do
      let(:cell_array) {
        [[["+", "2", "12"], ["*", "3", "a1"], ["b2"]]]
      }
      let(:result) {
        [[14, 42, '#ERR']]
      }
      it 'should return 3 valid numbers' do
        allow(subject).to receive(:cell_array).and_return(cell_array)
        expect(subject.run).to eq(result)
      end
    end

    context 'when there are multiple cells and error simbol' do
      let(:cell_array) {
        [[["-", "12", "2"], ["*", "3", "a"]]]
      }
      let(:result) {
        [[-10, '#ERR']]
      }
      it 'should return 3 valid numbers' do
        allow(subject).to receive(:cell_array).and_return(cell_array)
        expect(subject.run).to eq(result)
      end
    end

    context 'when there are multiple cells and error simbol' do
      let(:cell_array) {
        [[["-", "12", "2"], ["*", "3", "a"]]]
      }
      let(:result) {
        [[-10, '#ERR']]
      }
      it 'should return 3 valid numbers' do
        allow(subject).to receive(:cell_array).and_return(cell_array)
        expect(subject.run).to eq(result)
      end
    end

  end
end
