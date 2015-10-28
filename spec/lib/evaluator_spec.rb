require 'spec_helper'
require 'tempfile'

describe Evaluator do
  let(:input_csv) { Tempfile.new(['test', '.csv']) }
  subject { described_class.new input_csv }
  describe '#cleanup' do
    before do
      input_csv.write(content)
      input_csv.flush
      input_csv.close
    end

    after do
      input_csv.close
    end
  end

  describe '.process_token' do
    context 'when it is a single expression' do
      let(:content) do
        <<END_OF_CSV
10 2 -
END_OF_CSV
      end

      it 'it should return the right result' do
        expect(subject.process_token(token))
      end
    end
  end
end
