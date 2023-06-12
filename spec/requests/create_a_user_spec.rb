require 'rails_helper'

RSpec.describe 'User Creation' do
  describe 'happy path' do
    it 'creates a user and returns their api key' do
      post '/api/v1/users', params: { user: { email: "test@test.com", password: "password", password_confirmation: "password" } }

      expect(response).to be_successful
      expect(response.status).to eq(201)

      body = JSON.parse(response.body, symbolize_names: true)

      expect(body).to be_a(Hash)
      expect(body[:data]).to be_a(Hash)
      expect(body[:data][:type]).to eq("users")
      expect(body[:data][:id]).to be_a(String)
      expect(body[:data][:attributes]).to be_a(Hash)
      expect(body[:data][:attributes][:email]).to eq("test@test.com")
      expect(body[:data][:attributes][:api_key]).to be_a(String)
    end
  end
  
  describe 'sad path' do
    it 'returns an error if email is already taken' do
      post '/api/v1/users', params: { user: { email: "test@test.com", password: "password", password_confirmation: "password" } }
      post '/api/v1/users', params: { user: { email: "test@test.com", password: "password", password_confirmation: "password" } }

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      body = JSON.parse(response.body, symbolize_names: true)
      
      expect(body).to be_a(Hash)
      expect(body[:error]).to eq("Email has already been taken")
    end

    it 'returns an error if password is missing' do
      post '/api/v1/users', params: { user: { password: "password", password_confirmation: "password" } }

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      body = JSON.parse(response.body, symbolize_names: true)
      
      expect(body).to be_a(Hash)
      expect(body[:error]).to eq("Email can't be blank")
    end
  end
end