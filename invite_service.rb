# Require dependencies
require 'json'

class InviteService

  attr_reader :locator, :default_gps, :range, :customers_file

  def initialize(options = {})
    @default_gps = options.fetch(:default_gps, [53.3381985, -6.2592576])
    @range = options.fetch(:range, 100)
    @customers_file = options.fetch(:customers_file, "customers.json")
    @locator = GeoLocator.new(@default_gps)
  end

  def find_customers_in_range
    customer_to_invite = []
    raise IOError, "No such file or directory! - #{customers_file}" if !File.exist?(customers_file)

    open(customers_file) do |file|
      file.each_line do |line|
        customer = JSON.parse(line)
        customer_to_invite << { user_id: customer["user_id"], name: customer["name"] } if locator.is_in_range?([customer["latitude"], customer["longitude"]], range)
      end
    end
    customer_to_invite.sort_by{ |hash| hash[:user_id] }
  end
end

class GeoLocator
  attr_reader :radius, :start_gps_point

  def initialize(start_gps_point, options = {})
    raise ArgumentError, 'GPS point is not valid' if !_gps_valid?(start_gps_point)
    @start_gps_point = start_gps_point
    @radius = options.fetch(:radius, 6371)
  end

  def is_in_range?(end_gps_point, range)
    raise ArgumentError, 'GPS point is not valid' if !_gps_valid?(end_gps_point)
    raise ArgumentError, 'Range is not valid number' if !_is_number?(range)

    distance(end_gps_point) <= range.to_f
  end

  def distance(end_gps_point)
    raise ArgumentError, 'GPS point is not valid' if !_gps_valid?(end_gps_point)

    central_angle(end_gps_point) * radius
  end

  def central_angle(end_gps_point)
    raise ArgumentError, 'GPS point is not valid' if !_gps_valid?(end_gps_point)

    latitude_1 = degrees_to_radians(start_gps_point.first)
    longitude_1 = degrees_to_radians(start_gps_point.last)
    latitude_2 = degrees_to_radians(end_gps_point.first)
    longitude_2 = degrees_to_radians(end_gps_point.last)
    delta_longitude = _delta(longitude_1, longitude_2)

    Math.acos(Math.sin(latitude_1) * Math.sin(latitude_2) + Math.cos(latitude_1) * Math.cos(latitude_2) * Math.cos(delta_longitude))
  end

  def degrees_to_radians(angle)
    raise ArgumentError, 'Angle is not valid number' if !_is_number?(angle)

    angle.to_f * Math::PI/180.0
  end

  def _delta(number1, number2)
    (number2 - number1).abs
  end

  def _gps_valid?(gps)
    gps.kind_of?(Array) && _is_number?(gps.first) && _is_number?(gps.last) && gps.size == 2
  end

  def _is_number?(string)
    true if Float(string) rescue false
  end
end
