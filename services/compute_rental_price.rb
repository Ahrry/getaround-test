require './services/base_service'
require './services/car_day_price'

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
    card_day_price = CarDayPrice.new(price: car.price_per_day, rental_length: rental.length)
    with_discount ? card_day_price.price_with_discount : card_day_price.price_without_discount
  end

  def km_price(car:, rental:)
    rental.distance * car.price_per_km
  end
end
