# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'ShowRats', type: :feature do
  describe 'Visiting a rat path' do
    let(:rat) { create(:rat) }
    it 'should show rat details w/o errors' do
      visit rats_path(rat)
      expect(page).to have_content(rat.name)
    end
  end
end
