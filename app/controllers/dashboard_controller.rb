class DashboardController < ApplicationController
  before_action :authenticate_user!
  def show
    @last_reading = current_user.readings.order(created_at: :desc).first
    @has_readings = current_user.readings.exists?
  end
end
