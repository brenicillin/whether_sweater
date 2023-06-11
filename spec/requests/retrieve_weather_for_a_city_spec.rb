require 'rails_helper'

RSpec.describe "GET /forecast" do
  describe "happy path" do
    it "can retrieve weather for a city" do

      get "/api/v1/forecast?location=cincinatti,oh"

      body = JSON.parse(response.body, symbolize_names: true)[:data][:attributes]

      current = body[:current_weather]
      daily = body[:daily_weather]
      hourly = body[:hourly_weather]

      expect(response).to be_successful
      expect(response.status).to eq(200)
      expect(response).to have_key(:data)
      expect(response[:data]).to have_key(:id)
      expect(response[:data]).to have_key(:type)
      expect(response[:data][:id]).to eq(nil)
      expect(response[:data][:type]).to eq("forecast")
      expect(response[:data]).to have_key(:attributes)

      expect(body).to have_key(:current_weather)
      expect(body).to have_key(:daily_weather)
      expect(body).to have_key(:hourly_weather)

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
      expect(hourly).to have_key(:conditions)
    end
  end
end