class ReadingCard < ApplicationRecord
  validates :card_id, uniqueness: { scope: :reading_id }
  validates :position, uniqueness: { scope: :reading_id }
  belongs_to :reading
  belongs_to :card
end
