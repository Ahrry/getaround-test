require './services/actor_amount'

puts ActorAmount.new(input_file_path: './level5/data/input.json').call
