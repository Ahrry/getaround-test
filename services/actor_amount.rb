require './services/compute_rental_fee'
require './services/compute_option_price'

class ActorAmount
  def initialize(input_file_path:, with_option: false)
    @with_option = with_option
    @input_file_path = input_file_path
    @json_rentals = JSON.parse(ComputeRentalFee.new(input_file_path: @input_file_path).call)['rentals']
  end

  def call
    result = []

    @json_rentals.each do |json_rental|
      rental = Rental.new(json: json_rental)

      hash = { id: rental.id, actions: actions(rental: rental) }
      hash.merge!(options: rental_option(rental: rental).keys) if @with_option

      result << hash
    end

    { rentals: result }.to_json
  end

  private

  def rental_option(rental:)
    ComputeOptionPrice.new(input_file_path: @input_file_path).call(rental_id: rental.id)
  end

  def actions(rental:)
    [
      driver_action(rental: rental),
      owner_action(rental: rental),
      insurance_action(rental: rental),
      assistance_action(rental: rental),
      drivy_action(rental: rental)
    ]
  end

  def driver_action(rental:)
    amount = rental.price
    amount += options_amount(rental: rental) if @with_option

    {
      who: 'driver',
      type: 'debit',
      amount: amount
    }
  end

  def insurance_action(rental:)
    {
      who: 'insurance',
      type: 'credit',
      amount: rental.commission['insurance_fee']
    }
  end

  def assistance_action(rental:)
    {
      who: 'assistance',
      type: 'credit',
      amount: rental.commission['assistance_fee']
    }
  end

  def drivy_action(rental:)
    amount = rental.commission['drivy_fee'] +
             rental_option(rental: rental)['additional_insurance'].to_i
    {
      who: 'drivy',
      type: 'credit',
      amount: amount
    }
  end

  def owner_action(rental:)
    amount = rental.price -
             rental.commission['insurance_fee'] -
             rental.commission['assistance_fee'] -
             rental.commission['drivy_fee']

    amount += owner_options_amount(rental: rental) if @with_option

    {
      who: 'owner',
      type: 'credit',
      amount: amount
    }
  end

  def owner_options_amount(rental:)
    rental_option(rental: rental)['gps'].to_i + rental_option(rental: rental)['baby_seat'].to_i
  end

  def options_amount(rental:)
    rental_option(rental: rental).values.sum
  end
end
