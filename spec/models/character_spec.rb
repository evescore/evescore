# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Character, type: :model do
  context '#wallet_journal' do
    let(:character) { build(:character) }
    it 'gets wallet journal from API' do
      expect { character.wallet_journal }.not_to raise_error
    end
  end

  context '#import_wallet' do
    let(:character) do
      user = create(:user)
      create(:character, user_id: user.id)
    end
    it 'imports wallet records' do
      expect { character.import_wallet }.not_to raise_error
    end
  end

  context '.create' do
    it 'creates a Character and triggers callbacks' do
      user = create(:user)
      expect { create(:character, user_id: user.id) }.not_to raise_error
    end
  end

  context '#update_tokens' do
    it 'updates tokens' do
      credentials = { 'token' => 'foobar', 'refresh_token' => 'foobar', 'expires_at' => Time.now.to_i }
      expect { Character.new.update_tokens(credentials) }.not_to raise_error
    end
  end
end
