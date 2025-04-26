class CreateReadingCards < ActiveRecord::Migration[7.2]
  def change
    create_table :reading_cards do |t|
      t.references :reading, null: false, foreign_key: true
      t.references :card, null: false, foreign_key: true
      t.integer :position
      t.boolean :reversed

      t.timestamps
    end
  end
end
