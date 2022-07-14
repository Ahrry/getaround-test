require 'json'
require './car'
require './rental'

class BaseService
  def initialize(input_file_path:)
    @input_json = File.read(input_file_path)
  end

  private

  def json_cars
    parsed_json['cars']
  end

  def json_car(id:)
    json_cars.detect{ |json_car| json_car['id'] == id }
  end

  def json_rentals
    parsed_json['rentals']
  end

  def json_rental(id:)
    json_rentals.detect{ |json_rental| json_rental['id'] == id }
  end

  def parsed_json
    JSON.parse(@input_json)
  end
end
