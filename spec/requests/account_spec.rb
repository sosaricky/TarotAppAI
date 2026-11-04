require "rails_helper"

RSpec.describe "Account", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user) }

  describe "GET /users/edit" do
    before { sign_in user }

    it "renders the edit account form in Spanish" do
      get edit_user_registration_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Editar mi cuenta")
      expect(response.body).to include("Actualizar")
      expect(response.body).to include("Cancelar mi cuenta")
    end
  end
end
