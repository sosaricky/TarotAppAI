# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)

    if successfully_sent?(resource)
      redirect_to new_user_session_path
    else
      redirect_to new_user_password_path, alert: "Email no registrado."
    end
  end
end
