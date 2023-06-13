require 'rails_helper'

RSpec.describe RoadTripService do
  before(:each) do
    stub_request(:get, "http://www.mapquestapi.com/directions/v2/route?key=#{ENV['MAPQUEST_API_KEY']}&from=Denver,CO&to=Pueblo,CO").
     to_return(body: File.read('spec/fixtures/road_trip.json'))
  end
  describe 'class methods' do
    it 'can get road trip data' do
      response = RoadTripService.get_travel_time('Denver,CO', 'Pueblo,CO')
      expect(response).to be_a(Hash)
    end
  end
end