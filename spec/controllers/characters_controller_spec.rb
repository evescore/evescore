# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CharactersController, type: :controller do
  before(:each) do
    @user = create(:user)
    @character = create(:character, user_id: @user.id)
  end
  describe 'DELETE character' do
    it 'deletes a character' do
      expect(@user.characters.count).to eq(1)
      delete :destroy, params: { character_id: @character.id }
      expect(response.status).to eq(302)
      expect(@user.characters.count).to eq(0)
    end
  end

  describe 'PATCH display_option' do
    it 'changes display option for character' do
      patch :display_option, params: { character_id: @character.id, character: { display_option: 'Private' } }
      expect(response.status).to eq(302)
      expect(Character.find(@character.id).display_option).to eq('Private')
    end
  end
end
