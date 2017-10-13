# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Login', type: :feature do
  context 'Login form' do
    let(:user) { create(:user) }
    it 'allows users to login' do
      user.confirm
      visit new_user_session_path
      fill_in :user_email, with: user.email
      fill_in :user_password, with: user.password
      click_on 'Log in'
      expect(current_path).to eq(characters_path)
    end
  end
end
