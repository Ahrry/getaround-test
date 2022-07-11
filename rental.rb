require 'date'

class Rental
  def initialize(json:)
    @json = json
  end

  def id
    @json['id']
  end

  def car_id
    @json['car_id']
  end

  def start_date
    Date.parse(@json['start_date'])
  end

  def end_date
    Date.parse(@json['end_date'])
  end

  def distance
    @json['distance']
  end

  def length
    # NOTE: we need to increment by one to include the first day
    (end_date - start_date).to_i + 1
  end
end
