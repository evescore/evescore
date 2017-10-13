# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  context '#import_character' do
    before(:each) do
      @user = create(:user)
      @character = build(:character)
      credentials = { 'token' => 'foobar', 'refresh_token' => 'foobar', 'expires_at' => Time.now.to_i }
      @omniauth_payload = {
        'credentials' => credentials,
        'extra' => {
          'raw_info' => {
            'CharacterID' => @character.id
          }
        }
      }
    end

    it 'imports character for user' do
      expect(@user.characters.count).to eq(0)
      expect { @user.import_character(@omniauth_payload) }.not_to raise_error
      expect(@user.characters.count).to eq(1)
    end
  end
end
