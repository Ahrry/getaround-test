require './services/compute_rental_fee'

RSpec.describe ComputeRentalFee do
  subject(:service) { described_class.new(input_file_path: input_file_path) }

  context 'level3' do
    let(:input_file_path) { './level3/data/input.json' }

    describe '#call' do
      let(:expected_json) { JSON.parse(File.read('./level3/data/expected_output.json')) }

      it 'does compute commission fees' do
        expect(JSON.parse(service.call)).to match(expected_json)
      end
    end
  end
end
