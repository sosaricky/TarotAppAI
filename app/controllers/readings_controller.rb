require_relative "../services/adapters/deep_seek_adapter"
require_relative "../services/reading_generator_service"
class ReadingsController < ApplicationController
  before_action :authenticate_user!, only: [ :new, :create, :show, :index ]

  def index
    @readings = current_user.readings.all
  end

  def show
    @reading = current_user.readings.find(params[:id])
  end

  def create
    adapter = Adapters::DeepSeekAdapter.new
    new_reading = ReadingGeneratorService.new(current_user.id, adapter).call
    redirect_to readings_path(reading_id: new_reading.id)
  end
end
