class MoveMessageToReadingCardsAndDeriveImagePath < ActiveRecord::Migration[7.2]
  def up
    add_column :reading_cards, :message, :text
    remove_column :cards, :message
    remove_column :cards, :image_path
  end

  def down
    add_column :cards, :image_path, :string
    add_column :cards, :message, :text
    remove_column :reading_cards, :message
  end
end
