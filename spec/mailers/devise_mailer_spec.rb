require "rails_helper"

RSpec.describe Devise::Mailer do
  describe "#reset_password_instructions" do
    it "renders the reset instructions in Spanish" do
      user = create(:user)
      token = user.send(:set_reset_password_token)

      mail = described_class.reset_password_instructions(user, token)

      expect(mail.subject).to eq("Instrucciones para restablecer tu contraseña")
      expect(mail.body.to_s).to include("Cambiar mi contraseña")
    end
  end
end
