require 'rails_helper'

RSpec.describe RoadTrip do
  describe 'initialize' do
    it 'exists and has attributes' do
      trip = RoadTrip.new('Denver,CO', 'Pueblo,CO', '01:43:00', { temperature: 50, condition: 'cloudy' })

      expect(trip).to be_a(RoadTrip)
      expect(trip.start_city).to eq('Denver,CO')
      expect(trip.end_city).to eq('Pueblo,CO')
      expect(trip.travel_time).to eq('01:43:00')
      expect(trip.weather_at_eta).to eq({ temperature: 50, condition: 'cloudy' })
    end
  end
end