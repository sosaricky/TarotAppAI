require "rails_helper"

RSpec.describe ImagePathGeneratorService do
  describe ".get_path_of_card" do
    before do
      allow(Dir).to receive(:glob).and_return(
        [
          "public/images/cards/The Fool.jpg",
          "public/images/cards/The Star.jpg"
        ]
      )
    end

    it "resolves the image path for a known card" do
      expect(described_class.get_path_of_card("El Loco"))
        .to eq("images/cards/The Fool.jpg")
    end

    it "resolves the image path regardless of the current locale" do
      I18n.with_locale(:es) do
        expect(described_class.get_path_of_card("El Loco"))
          .to eq("images/cards/The Fool.jpg")
      end
    end

    it "raises when no image matches the card" do
      expect { described_class.get_path_of_card("El Mundo") }
        .to raise_error(ImagePathGeneratorService::CardImageNotFoundError)
    end
  end
end
