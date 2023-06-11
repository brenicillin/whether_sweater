class Api::V1::ForecastController < ApplicationController
  def index
    render json: ForecastSerializer.new(ForecastService.get_forecast(params[:location])).serialize_forecast
  end
end