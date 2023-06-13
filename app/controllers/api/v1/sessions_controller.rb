class Api::V1::SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:user][:email])
    if user && user.authenticate(params[:user][:password])
      render json: UsersSerializer.serialize(user), status: 200
    else
      render json: { error: 'Invalid credentials' }, status: 400
    end
  end
end