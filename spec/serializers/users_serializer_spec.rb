require 'rails_helper'

RSpec.describe UsersSerializer do
  describe 'class methods' do
    it 'serializes a user' do
      @user = User.create!(email: "bob@bob.com", password: "password", password_confirmation: "password")

      response = UsersSerializer.creation(@user)

      expect(response).to be_a(Hash)
      expect(response[:data]).to be_a(Hash)
      expect(response[:data][:type]).to eq("users")
      expect(response[:data][:id]).to eq(@user.id.to_s)
      expect(response[:data][:attributes]).to be_a(Hash)
      expect(response[:data][:attributes][:email]).to eq(@user.email)
      expect(response[:data][:attributes][:api_key]).to eq(@user.api_key)
    end
  end
end