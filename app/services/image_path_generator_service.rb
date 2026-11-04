# frozen_string_literal: true

# Resolves the image path for a card based on its name.
class ImagePathGeneratorService
  class CardImageNotFoundError < StandardError; end

  def self.get_path_of_card(card_name)
    image_name = I18n.t(
      card_name.downcase.gsub(" ", "_").to_sym,
      scope: "tarot.cartas",
      locale: :en
    )
    file_name = "#{image_name}.jpg"

    entry = get_path_with_name_list.find { |path_and_name| path_and_name[:name] == file_name }
    raise CardImageNotFoundError, "No image found for card: #{card_name}" if entry.nil?

    entry[:path].gsub("public/", "")
  end

  def self.get_path_with_name_list
    path_list = Dir.glob(ENV.fetch("CARDS_IMAGES_PATH") { "public/images/cards/*.jpg" })
    path_list.map { |path| { name: File.basename(path), path: path } }
  end
  private_class_method :get_path_with_name_list
end
