class ForecastService
  
  def self.get_url(url)
    response = Faraday.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.get_lat_long(location)
    response = get_url("https://www.mapquestapi.com/geocoding/v1/address?key=#{ENV['MAPQUEST_API_KEY']}&location=#{location}")
    latlong = response[:results][0][:locations][0][:latLng]
    latlong.values.join(',')
  end

  def self.get_forecast(location)
    latlong = ForecastService.get_lat_long(location)
    forecast = get_url("http://api.weatherapi.com/v1/forecast.json?key=#{ENV['WEATHER_API_KEY']}&q=#{latlong}&days=5")
  end
end