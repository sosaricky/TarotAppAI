# Seeds the canonical major arcana cards.
Card::MAJOR_ARCANA_NAMES.each do |card_name|
  Card.find_or_create_by!(name: card_name)
end
