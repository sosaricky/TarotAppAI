require_relative "../services/adapters/deep_seek_adapter"
require_relative "../services/reading_generator_service"
class ReadingsController < ApplicationController
  before_action :authenticate_user!, only: [ :new, :create ]

  def index
    id = params[:reading_id]
    @reading = Reading.find_by(id: id) if id.present?
  end

  def show
    @reading = Reading.find(params[:id])
  end

  def create
    adapter = Adapters::DeepSeekAdapter.new
    new_reading = ReadingGeneratorService.new(current_user.id, adapter).call
    redirect_to readings_path(reading_id: new_reading.id)
  end
end
