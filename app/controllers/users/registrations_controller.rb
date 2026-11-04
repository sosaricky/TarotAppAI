# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :reject_spam, only: :create

  private

  # Honeypot: bots fill hidden fields, humans do not. If the hidden field
  # has any value, silently drop the request by pretending it succeeded.
  def reject_spam
    return if params.dig(:user, :website).blank?

    redirect_to new_user_session_path
  end
end
