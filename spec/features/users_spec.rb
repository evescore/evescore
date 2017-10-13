# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Users', type: :feature do
  context 'Login' do
    it 'should work' do
      user = create(:user)
      login_as(user, scope: :user)
    end
  end
end
