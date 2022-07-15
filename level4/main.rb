require './services/actor_amount'

puts ActorAmount.new(input_file_path: './level4/data/input.json').call
