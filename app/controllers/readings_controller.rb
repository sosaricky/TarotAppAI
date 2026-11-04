class ReadingsController < ApplicationController
  before_action :authenticate_user!, only: [ :create, :show, :index ]

  def index
    @readings = current_user.readings.all
  end

  def show
    @reading = current_user.readings.find(params[:id])
  end

  def create
    adapter = Adapters::DeepSeekAdapter.new
    new_reading = ReadingGeneratorService.new(current_user.id, adapter).call
    redirect_to reading_path(new_reading)
  rescue ReadingResponseParser::InvalidResponseError, Adapters::DeepSeekAdapter::ApiError => e
    Rails.logger.error("Reading generation failed: #{e.message}")
    redirect_to dashboard_path, alert: "No se pudo generar tu lectura. Intentá de nuevo."
  end
end
