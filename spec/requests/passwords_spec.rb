require "rails_helper"

RSpec.describe "Passwords", type: :request do
  describe "GET /users/password/new" do
    it "renders the forgot password form in Spanish" do
      get new_user_password_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Olvidaste tu contraseña")
      expect(response.body).to include("Enviarme instrucciones")
    end
  end

  describe "GET /users/password/edit" do
    it "renders the change password form in Spanish" do
      user = create(:user)
      token = user.send(:set_reset_password_token)

      get edit_user_password_path, params: { reset_password_token: token }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Cambiar tu contraseña")
      expect(response.body).to include("Nueva contraseña")
    end
  end
end
