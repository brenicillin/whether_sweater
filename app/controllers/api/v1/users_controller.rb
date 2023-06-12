class Api::V1::UsersController < ApplicationController
  def create
    user = User.new(user_params)
    if user.save
      render json: UsersSerializer.creation(user), status: 201
    else
      render json: { error: user.errors.full_messages.to_sentence }, status: 400
    end
  end

  private
  
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end