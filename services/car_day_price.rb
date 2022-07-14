require 'byebug'

DISCOUNT_FACTORS = {
  after_ten_days: { nb_days: 10, factor: 0.5 },
  after_four_days: { nb_days: 4, factor: 0.3 },
  after_one_day: { nb_days: 1, factor: 0.1 }
}

class CarDayPrice
  def initialize(price:, rental_length:)
    @price = price
    @rental_length = rental_length
  end

  def price_without_discount
    @rental_length * @price
  end

  # rubocop:disable Metrics/AbcSize
  def price_with_discount
    [
      nb_days_with_fifty_percent_discount * @price * (1 - DISCOUNT_FACTORS[:after_ten_days][:factor]),
      nb_days_with_thirty_percent_discount * @price * (1 - DISCOUNT_FACTORS[:after_four_days][:factor]),
      nb_days_with_ten_percent_discount * @price * (1 - DISCOUNT_FACTORS[:after_one_day][:factor]),
      nb_days_without_discount * @price
    ].sum
  end
  # rubocop:enable Metrics/AbcSize

  private

  def nb_days_with_fifty_percent_discount
    nb_days = @rental_length - DISCOUNT_FACTORS[:after_ten_days][:nb_days]

    nb_days.negative? ? 0 : nb_days
  end

  def nb_days_with_thirty_percent_discount
    nb_days = @rental_length -
              nb_days_with_fifty_percent_discount -
              DISCOUNT_FACTORS[:after_four_days][:nb_days]

    nb_days.negative? ? 0 : nb_days
  end

  def nb_days_with_ten_percent_discount
    nb_days = @rental_length -
              nb_days_with_fifty_percent_discount -
              nb_days_with_thirty_percent_discount -
              DISCOUNT_FACTORS[:after_one_day][:nb_days]

    nb_days.negative? ? 0 : nb_days
  end

  def nb_days_without_discount
    @rental_length -
      nb_days_with_fifty_percent_discount -
      nb_days_with_thirty_percent_discount -
      nb_days_with_ten_percent_discount
  end
end
