class AddMessageToCards < ActiveRecord::Migration[7.2]
  def change
    add_column :cards, :message, :text
  end
end
