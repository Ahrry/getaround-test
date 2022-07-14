require './services/compute_rental_price'

puts ComputeRentalPrice.new(input_file_path: './level2/data/input.json').call(with_discount: true)
