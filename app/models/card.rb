class Card < ApplicationRecord
  # Canonical list of the 22 major arcana accepted in a reading.
  MAJOR_ARCANA_NAMES = [
    "El Loco",
    "El Mago",
    "La Sacerdotisa",
    "La Emperatriz",
    "El Emperador",
    "El Papa",
    "Los Enamorados",
    "El Carro",
    "La Fuerza",
    "El Ermitaño",
    "La Rueda de la Fortuna",
    "La Justicia",
    "El Colgado",
    "La Muerte",
    "La Templanza",
    "El Diablo",
    "La Torre",
    "La Estrella",
    "La Luna",
    "El Sol",
    "El Juicio",
    "El Mundo"
  ].freeze

  has_many :reading_cards, dependent: :destroy
  has_many :readings, through: :reading_cards

  # The image path is derived from the card name instead of being stored,
  # so it can never go stale or contain a hardcoded filesystem path.
  def image_path
    ImagePathGeneratorService.get_path_of_card(name)
  end
end
