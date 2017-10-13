# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def crest
    redirect_to root_path && return unless current_user
    omniauth_payload = request.env['omniauth.auth']
    current_user.import_character(omniauth_payload)
    redirect_to characters_path, notice: 'Your character has been successfully imported. Initial sync has been queued. In a moment your data will show up'
  end
end
