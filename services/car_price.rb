require 'byebug'

class CarPrice
  def initialize(price:, rental_length:)
    @price = price
    @rental_length = rental_length
  end

  def per_day(with_discount: false)
    factor = 1
    factor -= discount if with_discount

    @price * factor
  end

  private

  def discount
    if @rental_length > 10
      0.5
    elsif @rental_length > 4
      0.3
    elsif @rental_length > 1
      0.1
    else
      0
    end
  end
end
