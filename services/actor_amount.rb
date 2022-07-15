require './services/compute_rental_fee'

class ActorAmount
  def initialize(input_file_path:)
    @json_rentals = JSON.parse(ComputeRentalFee.new(input_file_path: input_file_path).call)['rentals']
  end

  def call
    result = []

    @json_rentals.each do |json_rental|
      rental = Rental.new(json: json_rental)

      result << {
        id: rental.id,
        actions: actions(rental: rental)
      }
    end

    { rentals: result }.to_json
  end

  private

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
    {
      who: 'driver',
      type: 'debit',
      amount: rental.price
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
    {
      who: 'drivy',
      type: 'credit',
      amount: rental.commission['drivy_fee']
    }
  end

  def owner_action(rental:)
    amount = rental.price -
             rental.commission['insurance_fee'] -
             rental.commission['assistance_fee'] -
             rental.commission['drivy_fee']

    {
      who: 'owner',
      type: 'credit',
      amount: amount
    }
  end
end
