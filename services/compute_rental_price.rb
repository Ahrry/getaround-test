require './services/base_service'
require './services/car_price'
require 'byebug'

class ComputeRentalPrice < BaseService
  def call(with_discount: false)
    result = []

    json_rentals.each do |json_rental|
      rental = Rental.new(json: json_rental)
      car = Car.new(json: json_car(id: rental.car_id))

      price = day_price(car: car, rental: rental, with_discount: with_discount).to_i +
              km_price(car: car, rental: rental).to_i

      result << { id: rental.id, price: price }
    end

    { rentals: result }.to_json
  end

  private

  def day_price(car:, rental:, with_discount:)
    car_price_per_day = CarPrice.new(
      price: car.price_per_day,
      rental_length: rental.length
    ).per_day(with_discount: with_discount)

    rental.length * car_price_per_day
  end

  def km_price(car:, rental:)
    rental.distance * car.price_per_km
  end
end
