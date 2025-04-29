class AddIndexToReadingCardsReadingIdAndPosition < ActiveRecord::Migration[7.2]
  def change
    add_index :reading_cards, [ :reading_id, :position ], unique: true, name: 'index_reading_cards_on_reading_and_position'
  end
end
