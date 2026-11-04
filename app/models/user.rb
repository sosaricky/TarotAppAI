class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :readings

  def daily_readings_count
    readings.created_today.count
  end

  def reached_daily_reading_limit?
    daily_readings_count >= self.class.daily_reading_limit
  end

  def self.daily_reading_limit
    Rails.application.config.x.daily_reading_limit
  end
end
