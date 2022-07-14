require './services/base_service'
require 'byebug'

class ComputeRentalPrice < BaseService
  def call
    result = []

    json_rentals.each do |json_rental|
      rental = Rental.new(json: json_rental)
      car = Car.new(json: json_car(id: rental.car_id))

      result << {
        id: rental.id,
        price: day_price(car: car, rental: rental) + km_price(car: car, rental: rental)
      }
    end

    { rentals: result }.to_json
  end

  private

  def day_price(car:, rental:)
    rental.length * car.price_per_day
  end

  def km_price(car:, rental:)
    rental.distance * car.price_per_km
  end
end
