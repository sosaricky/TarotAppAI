class CreateReadings < ActiveRecord::Migration[7.2]
  def change
    create_table :readings do |t|
      t.string :name
      t.text :message
      t.text :conclusion
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
