require './services/actor_amount'

RSpec.describe ActorAmount do
  subject(:service) { described_class.new(input_file_path: input_file_path) }

  context 'level4' do
    let(:input_file_path) { './level4/data/input.json' }

    describe '#call' do
      let(:expected_json) { JSON.parse(File.read('./level4/data/expected_output.json')) }

      it 'does get actor amount' do
        expect(JSON.parse(service.call)).to match(expected_json)
      end
    end
  end
end
