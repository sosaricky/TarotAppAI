require "rails_helper"

RSpec.describe "I18n" do
  it "uses Spanish as the default locale" do
    expect(I18n.default_locale).to eq(:es)
  end

  it "translates Devise messages to Spanish" do
    expect(I18n.t("devise.failure.invalid")).to eq("Correo o contraseña no válidos.")
  end
end
