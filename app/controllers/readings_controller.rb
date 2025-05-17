require_relative "../services/adapters/deep_seek_adapter"
require_relative "../services/reading_generator_service"
class ReadingsController < ApplicationController
  before_action :authenticate_user!, only: [ :new, :create ]

  def index
    @reading = Reading.find_by(id: params[:reading_id]) if params[:reading_id].present?
  end

  def show
    @reading = Reading.find(params[:id])
  end

  def create
    adapter = Adapters::DeepSeekAdapter.new
    reading = ReadingGeneratorService.new(current_user.id, adapter).call
    redirect_to readings_path(reading_id: reading.id)
  end

  def destroy;end
end
