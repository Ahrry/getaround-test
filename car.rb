class Car
  def initialize(json:)
    @json = json
  end

  def id
    @json['id']
  end

  def price_per_day
    @json['price_per_day']
  end

  def price_per_km
    @json['price_per_km']
  end
end
