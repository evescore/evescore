# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'ShowFactions', type: :feature do
  describe 'Visiting a show faction path' do
    let(:faction) { create(:faction) }
    it 'should show a faction w/o errors' do
      visit faction_path(faction)
      expect(page).to have_content(faction.name)
    end
  end
end
