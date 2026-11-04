class ReadingsController < ApplicationController
  before_action :authenticate_user!, only: [ :create, :index ]

  def index
    @readings = current_user.readings.all
  end

  def show
    @reading = Reading.find(params[:id])
    return if @reading.user.nil? || @reading.user == current_user

    redirect_to root_path, alert: "No tenés acceso a esa lectura."
  end

  def create
    new_reading = generate_reading(current_user)
    redirect_to reading_path(new_reading)
  rescue ReadingResponseParser::InvalidResponseError, Adapters::DeepSeekAdapter::ApiError => e
    handle_generation_error(e)
  end

  def anonymous
    new_reading = generate_reading(nil)
    redirect_to reading_path(new_reading)
  rescue ReadingResponseParser::InvalidResponseError, Adapters::DeepSeekAdapter::ApiError => e
    handle_generation_error(e)
  end

  private

  def generate_reading(user)
    adapter = Adapters::DeepSeekAdapter.new
    ReadingGeneratorService.new(user, adapter).call
  end

  def handle_generation_error(error)
    Rails.logger.error("Reading generation failed: #{error.message}")
    redirect_to root_path, alert: "No se pudo generar tu lectura. Intentá de nuevo."
  end
end
