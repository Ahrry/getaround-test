require 'byebug'

DISCOUNT_FACTORS = [
  { after_nb_day: 10, factor: 0.5 },
  { after_nb_day: 4, factor: 0.3 },
  { after_nb_day: 1, factor: 0.1 },
  { after_nb_day: 0, factor: 0 }
].freeze

class CarDayPrice
  def initialize(price:, rental_length:)
    @price = price
    @rental_length = rental_length
  end

  def price_without_discount
    @rental_length * @price
  end

  def price_with_discount
    rental_length = @rental_length

    after_nb_days.map do |nb_day|
      remaining_days = rental_length - nb_day
      nb_days_with_discount = remaining_days.negative? ? 0 : remaining_days
      rental_length -= nb_days_with_discount

      nb_days_with_discount * @price * (1 - discount_factor(nb_day: nb_day))
    end.sum
  end

  private

  def discount_factor(nb_day:)
    DISCOUNT_FACTORS.detect { |discount_factor| discount_factor[:after_nb_day] == nb_day }[:factor]
  end

  def after_nb_days
    @after_nb_days ||= DISCOUNT_FACTORS.map { |discount_factor| discount_factor[:after_nb_day] }.sort { |a, b| b <=> a }
  end
end
