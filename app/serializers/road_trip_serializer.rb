class RoadTripSerializer
  def initialize(trip)
    @trip = trip
  end

  def serialize_road_trip
     {
      data: {
        id: nil,
        type: 'road_trip',
        attributes: {
          start_city: @trip.start_city,
          end_city: @trip.end_city,
          travel_time: @trip.travel_time,
          weather_at_eta: @trip.travel_time == 'Impossible' ? {} : {
            datetime: @trip.weather_at_eta[:time],
            temperature: @trip.weather_at_eta[:temp_f],
            condition: @trip.weather_at_eta[:condition][:text]
          }
        }
      }
     }
  end
end