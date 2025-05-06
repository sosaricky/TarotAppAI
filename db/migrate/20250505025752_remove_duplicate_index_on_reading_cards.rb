class RemoveDuplicateIndexOnReadingCards < ActiveRecord::Migration[7.2]
  def change
    remove_index :reading_cards, name: :index_on_reading_id_and_position
  end
end
