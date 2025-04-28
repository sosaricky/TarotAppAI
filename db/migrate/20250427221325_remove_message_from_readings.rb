class RemoveMessageFromReadings < ActiveRecord::Migration[7.2]
  def change
    remove_column :readings, :message, :string
  end
end
