# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::OmniauthCallbacksController, type: :controller do
  include Devise::Test::ControllerHelpers
  describe 'CREST callback' do
    it 'should create a character for a logged in user' do
      user = create(:user)
      character = build(:character, user_id: user.id)
      allow(request.env['warden']).to receive(:authenticate!).and_return(user)
      allow(controller).to receive(:current_user).and_return(user)
      @request.env['devise.mapping'] = Devise.mappings[:user]
      credentials = { 'token' => character.access_token, 'refresh_token' => character.refresh_token, 'expires_at' => character.token_expires.to_i }
      @request.env['omniauth.auth'] = {
        'credentials' => credentials,
        'extra' => {
          'raw_info' => {
            'CharacterID' => character.id
          }
        }
      }
      expect(Character.count).to eq(0)
      post :crest
      expect(response.status).to eq(302)
      expect(Character.count).to eq(1)
    end
  end
end
