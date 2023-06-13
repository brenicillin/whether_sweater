class RoadTrip
  attr_reader :id,
              :start_city,
              :end_city,
              :travel_time,
              :weather_at_eta
  def initialize(origin, destination, travel_time, forecast)
    @id = nil
    @start_city = origin
    @end_city = destination
    if travel_time == nil
      @travel_time = 'Impossible'
    else
      @travel_time = travel_time
    end
    @weather_at_eta = forecast
  end
end