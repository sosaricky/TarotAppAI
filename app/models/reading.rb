class Reading < ApplicationRecord
  # A reading with no user is an anonymous reading.
  belongs_to :user, optional: true
  has_many :reading_cards, dependent: :destroy
  has_many :cards, through: :reading_cards

  scope :created_today, -> { where("created_at >= ?", Time.current.beginning_of_day) }
end
