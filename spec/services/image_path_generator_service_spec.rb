require "rails_helper"

RSpec.describe ImagePathGeneratorService do
  describe ".get_path_of_card" do
    it "resolves the image path for a known card" do
      expect(described_class.get_path_of_card("El Loco"))
        .to eq("/images/cards/The Fool.jpg")
    end

    it "resolves the image path regardless of the current locale" do
      I18n.with_locale(:es) do
        expect(described_class.get_path_of_card("El Loco"))
          .to eq("/images/cards/The Fool.jpg")
      end
    end

    it "resolves multi-word card names" do
      expect(described_class.get_path_of_card("La Rueda de la Fortuna"))
        .to eq("/images/cards/Wheel of Fortune.jpg")
    end
  end
end
