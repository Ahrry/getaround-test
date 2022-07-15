class Option
  def initialize(json:)
    @json = json
  end

  def id
    @json['id']
  end

  def rental_id
    @json['rental_id']
  end

  def type
    @json['type']
  end
end
