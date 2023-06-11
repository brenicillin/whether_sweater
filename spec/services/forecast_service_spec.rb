require 'rails_helper'

RSpec.describe ForecastService do
  before(:each) do
    stub_request(:get, "http://api.weatherapi.com/v1/forecast.json?days=5&key=#{ENV['WEATHER_API_KEY']}&q=39.10713,-84.50413").
     to_return(status: 200, body: File.read('spec/fixtures/cincinatti_forecast.json'), headers: {})
    stub_request(:get, "https://www.mapquestapi.com/geocoding/v1/address?key=#{ENV['MAPQUEST_API_KEY']}&location=Cincinatti,%20OH").
     to_return(status: 200, body: File.read('spec/fixtures/cincinatti_latlon.json'), headers: {})
  end
  describe 'class methods' do
    it 'returns lat and long for a given location' do
      lat_long = ForecastService.get_lat_long('Cincinatti, OH')
      expect(lat_long).to be_a(String)
      expect(ForecastService.get_lat_long('Cincinatti, OH')).to eq('39.10713,-84.50413')
    end

    it 'returns forecast for a given location' do
      weather = ForecastService.get_forecast('Cincinatti, OH')
      current = weather[:current]
      forecast = weather[:forecast]
      hourly = forecast[:forecastday][0][:hour]
      
      expect(current).to be_a(Hash)
      expect(current[:last_updated]).to be_a(String)
      expect(current[:temp_f]).to be_a(Float)
      expect(current[:feelslike_f]).to be_a(Float)
      expect(current[:humidity]).to be_a(Integer)
      expect(current[:uv]).to be_a(Float)
      expect(current[:vis_miles]).to be_a(Float)
      expect(current[:condition]).to be_a(Hash)
      expect(current[:condition][:text]).to be_a(String)

      expect(forecast).to be_a(Hash)
      expect(forecast[:forecastday]).to be_an(Array)
      expect(forecast[:forecastday].count).to eq(5)
      expect(forecast[:forecastday][0]).to be_a(Hash)
      expect(forecast[:forecastday][0][:date]).to be_a(String)
      expect(forecast[:forecastday][0][:astro]).to be_a(Hash)
      expect(forecast[:forecastday][0][:astro][:sunrise]).to be_a(String)
      expect(forecast[:forecastday][0][:astro][:sunset]).to be_a(String)
      expect(forecast[:forecastday][0][:day][:maxtemp_f]).to be_a(Float)
      expect(forecast[:forecastday][0][:day][:mintemp_f]).to be_a(Float)
      expect(forecast[:forecastday][0][:day][:condition][:text]).to be_a(String)
      expect(forecast[:forecastday][0][:day][:condition][:icon]).to be_a(String)

      expect(hourly).to be_an(Array)
      expect(hourly.count).to eq(24)
      expect(hourly[0][:time]).to be_a(String)
      expect(hourly[0][:temp_f]).to be_a(Float)
      expect(hourly[0][:condition]).to be_a(Hash)
      expect(hourly[0][:condition][:text]).to be_a(String)
      expect(hourly[0][:condition][:icon]).to be_a(String)
    end
  end
end