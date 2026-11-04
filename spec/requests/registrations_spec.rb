require "rails_helper"

RSpec.describe "Registrations", type: :request do
  let(:sign_up_params) do
    {
      user: {
        email: "new-user@example.com",
        password: "password123",
        password_confirmation: "password123"
      }
    }
  end

  describe "GET /users/sign_up" do
    it "renders the honeypot field" do
      get new_user_registration_path

      expect(response.body).to include('name="user[website]"')
    end
  end

  describe "POST /users" do
    it "creates a user when the honeypot is empty" do
      expect { post user_registration_path, params: sign_up_params }
        .to change(User, :count).by(1)
    end

    it "does not create a user when the honeypot is filled" do
      spam_params = {
        user: sign_up_params[:user].merge(website: "http://spam.example")
      }

      expect { post user_registration_path, params: spam_params }
        .not_to change(User, :count)

      expect(response).to redirect_to(new_user_session_path)
    end

    it "shows validation errors when sign-up fails" do
      create(:user, email: "taken@example.com")

      post user_registration_path, params: {
        user: {
          email: "taken@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }

      expect(response.body).to include("auth-errors")
    end

    it "throttles sign-ups beyond the limit from the same IP" do
      limit = ENV.fetch("SIGN_UP_LIMIT", "3").to_i

      limit.times { post user_registration_path, params: sign_up_params }

      post user_registration_path, params: sign_up_params

      expect(response).to have_http_status(:too_many_requests)
    end
  end
end
