require 'rails_helper'

RSpec.describe "GET /forecast" do
  before(:each) do
    stub_request(:get, "http://api.weatherapi.com/v1/forecast.json?days=5&key=#{ENV['WEATHER_API_KEY']}&q=39.10713,-84.50413").
     to_return(status: 200, body: File.read('spec/fixtures/cincinatti_forecast.json'), headers: {})
    stub_request(:get, "https://www.mapquestapi.com/geocoding/v1/address?key=#{ENV['MAPQUEST_API_KEY']}&location=cincinatti,oh").
     to_return(status: 200, body: File.read('spec/fixtures/cincinatti_latlon.json'), headers: {})
  end
  describe "happy path" do
    it "can retrieve weather for a city" do

      get "/api/v1/forecast?location=cincinatti,oh"

      body = JSON.parse(response.body, symbolize_names: true)

      current = body[:data][:attributes][:current_weather]
      daily = body[:data][:attributes][:daily_weather][0]
      hourly = body[:data][:attributes][:hourly_weather][0]

      expect(response).to be_successful
      expect(response.status).to eq(200)

      expect(body).to have_key(:data)
      expect(body[:data]).to have_key(:id)
      expect(body[:data]).to have_key(:type)
      expect(body[:data][:id]).to eq(nil)
      expect(body[:data][:type]).to eq("forecast")
      expect(body[:data]).to have_key(:attributes)

      expect(body[:data][:attributes]).to have_key(:current_weather)
      expect(body[:data][:attributes]).to have_key(:daily_weather)
      expect(body[:data][:attributes]).to have_key(:hourly_weather)
      
      expect(current).to have_key(:last_updated)
      expect(current).to have_key(:temperature)
      expect(current).to have_key(:feels_like)
      expect(current).to have_key(:humidity)
      expect(current).to have_key(:uvi)
      expect(current).to have_key(:visibility)
      expect(current).to have_key(:condition)

      expect(daily).to have_key(:date)
      expect(daily).to have_key(:sunrise)
      expect(daily).to have_key(:sunset)
      expect(daily).to have_key(:max_temp)
      expect(daily).to have_key(:min_temp)
      expect(daily).to have_key(:condition)

      expect(hourly).to have_key(:time)
      expect(hourly).to have_key(:temperature)
      expect(hourly).to have_key(:condition)
    end
  end
end