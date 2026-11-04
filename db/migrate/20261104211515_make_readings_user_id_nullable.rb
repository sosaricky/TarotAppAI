class MakeReadingsUserIdNullable < ActiveRecord::Migration[7.2]
  def change
    change_column_null :readings, :user_id, true
  end
end
