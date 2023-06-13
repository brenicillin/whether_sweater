class RoadTripFacade
  def road_trip(origin, destination)
    travel_time = RoadTripService.get_travel_time(origin, destination)
    if travel_time[:route].has_key?(:routeError)
      RoadTrip.new(origin, destination, nil, nil)
    else
      eta = travel_time[:route][:formattedTime]
      forecast = get_destination_forecast(destination, eta)
      RoadTrip.new(origin, destination, eta, forecast)
    end
  end

  private
  def arrival_time(eta)
    Time.now + eta.to_i
  end

  def get_destination_forecast(destination, eta)
    weather = ForecastService.get_forecast(destination)
    data = weather[:forecast][:forecastday].first[:hour].find do |hour|
      # require 'pry'; binding.pry
      Time.at(hour[:time_epoch]).hour == arrival_time(eta).hour
    end
    data
    # require 'pry'; binding.pry
  end
end