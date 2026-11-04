require "rails_helper"

RSpec.describe "Sessions", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user, password: "password123") }

  describe "POST /users/sign_in" do
    it "does not show a flash notice after signing in" do
      post user_session_path, params: { user: { email: user.email, password: "password123" } }

      expect(response).to have_http_status(:redirect)
      expect(flash[:notice]).to be_nil
    end
  end

  describe "DELETE /users/sign_out" do
    before { sign_in user }

    it "does not show a flash notice after signing out" do
      delete destroy_user_session_path

      expect(response).to have_http_status(:redirect)
      expect(flash[:notice]).to be_nil
    end
  end
end
