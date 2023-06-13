require 'rails_helper'

RSpec.describe 'New Road Trip' do
  before(:each) do
    @user = User.create!(email: 'i@just.need', password: 'a_key', password_confirmation: 'a_key')
    @key = @user.api_key
    stub_request(:get, "http://www.mapquestapi.com/directions/v2/route?key=#{ENV['MAPQUEST_API_KEY']}&from=Denver,CO&to=Pueblo,CO").
     to_return(body: File.read('spec/fixtures/road_trip.json'))
    stub_request(:get, "https://www.mapquestapi.com/geocoding/v1/address?key=#{ENV['MAPQUEST_API_KEY']}&location=Pueblo,CO").
     to_return(body: File.read('spec/fixtures/pueblo_geocode.json'))
    stub_request(:get, "http://api.weatherapi.com/v1/forecast.json?days=5&key=#{ENV['WEATHER_API_KEY']}&q=38.26375,-104.61252").
     to_return(body: File.read('spec/fixtures/pueblo_forecast.json'))
    stub_request(:get, "http://www.mapquestapi.com/directions/v2/route?from=London,UK&key=#{ENV['MAPQUEST_API_KEY']}&to=Pueblo,CO").
     to_return(body: File.read('spec/fixtures/impossible_trip.json'))
  end

  describe 'Happy Path' do
    it 'can create a new road trip' do
      post '/api/v1/road_trip', params: { origin: 'Denver,CO', destination: 'Pueblo,CO', api_key: @user.api_key }
      expect(response).to be_successful
      expect(response.status).to eq(200)

      body = JSON.parse(response.body, symbolize_names: true)
      attributes = body[:data][:attributes]
      forecast = attributes[:weather_at_eta]

      expect(body).to be_a(Hash)
      expect(body).to have_key(:data)
      expect(body[:data]).to be_a(Hash)
      expect(body[:data]).to have_key(:id)
      expect(body[:data][:id]).to eq(nil)
      expect(body[:data]).to have_key(:type)
      expect(body[:data][:type]).to eq('road_trip')
      expect(body[:data]).to have_key(:attributes)
      expect(body[:data][:attributes]).to be_a(Hash)

      expect(attributes).to have_key(:start_city)
      expect(attributes[:start_city]).to be_a(String)
      expect(attributes).to have_key(:end_city)
      expect(attributes[:end_city]).to be_a(String)
      expect(attributes).to have_key(:travel_time)
      expect(attributes[:travel_time]).to be_a(String)
      expect(attributes).to have_key(:weather_at_eta)

      expect(forecast).to be_a(Hash)
      expect(forecast).to have_key(:temperature)
      expect(forecast[:temperature]).to be_a(Numeric)
      expect(forecast).to have_key(:condition)
      expect(forecast[:condition]).to be_a(String)
    end

    it 'will return impossible if the trip is impossible' do
      post '/api/v1/road_trip', params: { origin: 'London,UK', destination: 'Pueblo,CO', api_key: @user.api_key }
      
      expect(response).to be_successful
      expect(response.status).to eq(200)

      body = JSON.parse(response.body, symbolize_names: true)

      expect(body).to be_a(Hash)
      expect(body).to have_key(:data)
      expect(body[:data]).to be_a(Hash)
      expect(body[:data][:attributes][:travel_time]).to eq('Impossible')
    end
  end

  describe 'Sad Path' do
    it 'returns an error if the api key is invalid' do
      post '/api/v1/road_trip', params: { origin: 'Denver,CO', destination: 'Pueblo,CO', api_key: 'invalid_key' }

      expect(response).to_not be_successful
      expect(response.status).to eq(401)

      body = JSON.parse(response.body, symbolize_names: true)

      expect(body).to be_a(Hash)
      expect(body).to have_key(:error)
      expect(body[:error]).to eq('Unauthorized')
    end
  end
end