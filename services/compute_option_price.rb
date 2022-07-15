require './option'

class ComputeOptionPrice < BaseService
  GPS_PRICE_PER_DAY = 500
  BABY_SEAT_PRICE_PER_DAY = 200
  ADDITIONAL_INSURANCE_PRICE_PER_DAY = 1000

  def call(rental_id:)
    json_rental = json_rental(id: rental_id)
    rental = Rental.new(json: json_rental)
    result = {}

    json_options_from_rental(rental_id: rental_id).each do |json_option|
      option = Option.new(json: json_option)

      result[option.type] = amount(rental: rental, option: option)
    end

    result
  end

  private

  def amount(rental:, option:)
    case option.type
    when 'gps'
      rental_length(rental_id: rental.id) * GPS_PRICE_PER_DAY
    when 'baby_seat'
      rental_length(rental_id: rental.id) * BABY_SEAT_PRICE_PER_DAY
    when 'additional_insurance'
      rental_length(rental_id: rental.id) * ADDITIONAL_INSURANCE_PRICE_PER_DAY
    end
  end

  def rental_length(rental_id:)
    json_rental = json_rental(id: rental_id)
    rental = Rental.new(json: json_rental)

    @rental_length ||= rental.length
  end
end
