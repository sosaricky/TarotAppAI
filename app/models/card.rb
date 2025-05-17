class Card < ApplicationRecord
  has_many :reading_cards, dependent: :destroy
  has_many :readings, through: :reading_cards
end
