class AddUniqueIndexToCardsName < ActiveRecord::Migration[7.2]
  def up
    # Reassign reading_cards that point to duplicate cards to the canonical
    # card (lowest id) for each name, then drop the duplicate cards.
    execute <<~SQL
      UPDATE reading_cards AS rc
      SET card_id = keep.id
      FROM cards AS c
      INNER JOIN (
        SELECT name, MIN(id) AS id
        FROM cards
        GROUP BY name
      ) AS keep ON keep.name = c.name
      WHERE rc.card_id = c.id
        AND c.id <> keep.id
    SQL

    execute <<~SQL
      DELETE FROM cards
      WHERE id NOT IN (
        SELECT MIN(id) FROM cards GROUP BY name
      )
    SQL

    add_index :cards, :name, unique: true
  end

  def down
    remove_index :cards, :name
  end
end
