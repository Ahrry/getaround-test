require './services/base_service'
require './services/compute_rental_price'

class ComputeRentalFee < BaseService
  COMMISSION_FACTOR = 0.3
  INSURANCE_FEE_FACTOR = 0.5
  ASSITANCE_PRICE_PER_DAY = 100

  # rubocop:disable Metrics/MethodLength
  def call
    result = []

    json_rentals.each do |json_rental|
      rental = Rental.new(json: json_rental)
      rental_price = rental_price(id: rental.id)

      result << {
        id: rental.id,
        price: rental_price,
        commission: commissions(commission_price: rental_price * COMMISSION_FACTOR, rental_length: rental.length)
      }
    end

    { rentals: result }.to_json
  end
  # rubocop:enable Metrics/MethodLength

  private

  def commissions(commission_price:, rental_length:)
    insurance_fee = insurance_fee(commission_price: commission_price)
    assistance_fee = assistance_fee(rental_length: rental_length)

    {
      insurance_fee: insurance_fee.to_i,
      assistance_fee: assistance_fee.to_i,
      drivy_fee: (commission_price - insurance_fee - assistance_fee).to_i
    }
  end

  def insurance_fee(commission_price:)
    commission_price * INSURANCE_FEE_FACTOR
  end

  def assistance_fee(rental_length:)
    rental_length * ASSITANCE_PRICE_PER_DAY
  end

  def rental_price(id:)
    rentals_json = ComputeRentalPrice.new(input_file_path: @input_file_path).call(with_discount: true)
    rentals_json_parsed = JSON.parse(rentals_json)['rentals']
    rentals_json_parsed.detect { |json_rental| json_rental['id'] == id }['price']
  end
end
