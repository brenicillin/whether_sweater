class RoadTripService
  def self.get_url(url)
    response = Faraday.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.get_travel_time(origin, destination)
    get_url("http://www.mapquestapi.com/directions/v2/route?key=#{ENV['MAPQUEST_API_KEY']}&from=#{origin}&to=#{destination}")
  end
end