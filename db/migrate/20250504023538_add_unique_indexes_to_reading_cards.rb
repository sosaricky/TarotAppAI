class AddUniqueIndexesToReadingCards < ActiveRecord::Migration[7.2]
  def change
    add_index :reading_cards, [ :reading_id, :card_id ], unique: true, name: 'index_on_reading_id_and_card_id'
    add_index :reading_cards, [ :reading_id, :position ], unique: true, name: 'index_on_reading_id_and_position'
  end
end
