require './services/compute_rental_price'

puts ComputeRentalPrice.new(input_file_path: './level1/data/input.json').call
