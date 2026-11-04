# frozen_string_literal: true

# Resolves the public web path for a card image based on its name.
class ImagePathGeneratorService
  def self.get_path_of_card(card_name)
    "/images/cards/#{I18n.t(
      card_name.downcase.gsub(" ", "_").to_sym,
      scope: "tarot.cartas",
      locale: :en
    )}.jpg"
  end
end
