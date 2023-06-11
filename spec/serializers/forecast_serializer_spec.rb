require 'rails_helper'

RSpec.describe ForecastSerializer do
  before(:each) do
    stub_request(:get, "http://api.weatherapi.com/v1/forecast.json?days=5&key=#{ENV['WEATHER_API_KEY']}&q=39.10713,-84.50413").
     to_return(status: 200, body: File.read('spec/fixtures/cincinatti_forecast.json'), headers: {})
    stub_request(:get, "https://www.mapquestapi.com/geocoding/v1/address?key=#{ENV['MAPQUEST_API_KEY']}&location=Cincinatti,%20OH").
     to_return(status: 200, body: File.read('spec/fixtures/cincinatti_latlon.json'), headers: {})
  end
  describe 'instance methods' do
    it 'properly serializes forecast data' do
      serialized = ForecastSerializer.new(ForecastService.get_forecast('Cincinatti, OH')).serialize_forecast
      current = serialized[:data][:attributes][:current_weather]
      daily = serialized[:data][:attributes][:daily_weather]
      hourly = serialized[:data][:attributes][:hourly_weather]
      
      expect(serialized).to be_a(Hash)
      expect(serialized[:data]).to be_a(Hash)
      expect(serialized[:data][:id]).to eq(nil)
      expect(serialized[:data][:type]).to eq('forecast')
      expect(serialized[:data][:attributes]).to be_a(Hash)

      expect(current).to be_a(Hash)
      expect(current[:last_updated]).to be_a(String)
      expect(current[:temperature]).to be_a(Float)
      expect(current[:feels_like]).to be_a(Float)
      expect(current[:humidity]).to be_a(Integer)
      expect(current[:uvi]).to be_a(Float)
      expect(current).to_not have_key(:temp_c)
      expect(current).to_not have_key(:feelslike_c)
      expect(current).to_not have_key(:vis_km)
      expect(current).to_not have_key(:wind_kph)
      expect(current).to_not have_key(:wind_dir)
      expect(current).to_not have_key(:wind_degree)
      expect(current).to_not have_key(:pressure_mb)
      expect(current).to_not have_key(:pressure_in)
      expect(current).to_not have_key(:precip_mm)
      expect(current).to_not have_key(:precip_in)

      expect(daily).to be_a(Array)
      expect(daily[0]).to be_a(Hash)
      expect(daily[0][:date]).to be_a(String)
      expect(daily[0][:sunrise]).to be_a(String)
      expect(daily[0][:sunset]).to be_a(String)
      expect(daily[0][:max_temp]).to be_a(Float)
      expect(daily[0][:min_temp]).to be_a(Float)
      expect(daily[0][:condition]).to be_a(String)
      expect(daily[0][:icon]).to be_a(String)
      expect(daily[0]).to_not have_key(:maxtemp_c)
      expect(daily[0]).to_not have_key(:mintemp_c)
      expect(daily[0]).to_not have_key(:avgtemp_c)
      expect(daily[0]).to_not have_key(:maxwind_kph)
      expect(daily[0]).to_not have_key(:totalprecip_mm)
      expect(daily[0]).to_not have_key(:avgvis_km)

      expect(hourly).to be_a(Array)
      expect(hourly[0]).to be_a(Hash)
      expect(hourly[0][:time]).to be_a(String)
      expect(hourly[0][:temperature]).to be_a(Float)
      expect(hourly[0][:condition]).to be_a(String)
      expect(hourly[0][:icon]).to be_a(String)
      expect(hourly[0]).to_not have_key(:temp_c)
      expect(hourly[0]).to_not have_key(:wind_kph)
      expect(hourly[0]).to_not have_key(:wind_dir)
      expect(hourly[0]).to_not have_key(:wind_degree)
      expect(hourly[0]).to_not have_key(:pressure_mb)
      expect(hourly[0]).to_not have_key(:pressure_in)
    end
  end
end