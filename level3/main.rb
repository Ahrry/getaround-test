require './services/compute_rental_fee'

puts ComputeRentalFee.new(input_file_path: './level3/data/input.json').call
