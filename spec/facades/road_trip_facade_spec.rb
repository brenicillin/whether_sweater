require 'rails_helper'

RSpec.describe 'Road Trip Facade' do
  before(:each) do
    stub_request(:get, "http://www.mapquestapi.com/directions/v2/route?key=#{ENV['MAPQUEST_API_KEY']}&from=Denver,CO&to=Pueblo,CO").
     to_return(body: File.read('spec/fixtures/road_trip.json'))
    stub_request(:get, "https://www.mapquestapi.com/geocoding/v1/address?key=#{ENV['MAPQUEST_API_KEY']}&location=Pueblo,CO").
     to_return(body: File.read('spec/fixtures/pueblo_geocode.json'))
    stub_request(:get, "http://api.weatherapi.com/v1/forecast.json?days=5&key=#{ENV['WEATHER_API_KEY']}&q=38.26375,-104.61252").
     to_return(body: File.read('spec/fixtures/pueblo_forecast.json'))
    stub_request(:get, "http://www.mapquestapi.com/directions/v2/route?from=London,UK&key=#{ENV['MAPQUEST_API_KEY']}&to=Pueblo,CO").
     to_return(body: File.read('spec/fixtures/impossible_trip.json'))
  end
  describe 'instance methods' do
    it 'can create a road trip object' do
      trip = RoadTripFacade.new.road_trip('Denver,CO', 'Pueblo,CO')
      
      expect(trip).to be_a(RoadTrip)
      expect(trip.start_city).to eq('Denver,CO')
      expect(trip.end_city).to eq('Pueblo,CO')
      expect(trip.travel_time).to eq('01:38:35')
      expect(trip.weather_at_eta).to be_a(Hash)
    end

    it 'can create a road trip object with impossible trip' do
      trip = RoadTripFacade.new.road_trip('London,UK', 'Pueblo,CO')

      expect(trip).to be_a(RoadTrip)
      expect(trip.start_city).to eq('London,UK')
      expect(trip.end_city).to eq('Pueblo,CO')
      expect(trip.travel_time).to eq('Impossible')
    end
  end
end