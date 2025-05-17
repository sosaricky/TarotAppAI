class ImagePathGeneratorService
  def self.get_path_of_card(card_name)
    path_and_name_found  = get_path_with_name_list.find do
      |path_and_name|
      path_and_name[:name] == "#{I18n.t("tarot.cartas.#{card_name}".downcase.gsub(" ", "_").to_sym)}.jpg"
    end
    path_and_name_found[:path].gsub("public/", "")
  end

  private

  def self.get_path_with_name_list
    path_list = Dir.glob(ENV.fetch("CARDS_IMAGES_PATH") { "public/images/cards/*.jpg" })
    path_list.map { |path| { name: path.match(/[^\/]*(\.jpg)/).to_s, path: path } }
  end
end
