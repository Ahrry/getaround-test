require './services/compute_rental_price'

RSpec.describe ComputeRentalPrice do
  subject(:service) { described_class.new(input_file_path: input_file_path) }

  context 'level1' do
    let(:input_file_path) { './level1/data/input.json' }

    describe '#call' do
      let(:expected_json) { JSON.parse(File.read('./level1/data/expected_output.json')) }

      it 'does compute rental price' do
        expect(JSON.parse(service.call)).to match(expected_json)
      end
    end
  end

  context 'level2' do
    let(:input_file_path) { './level2/data/input.json' }

    describe '#call' do
      let(:expected_json) { JSON.parse(File.read('./level2/data/expected_output.json')) }

      it 'does compute rental price with discount' do
        expect(JSON.parse(service.call(with_discount: true))).to match(expected_json)
      end
    end
  end
end
