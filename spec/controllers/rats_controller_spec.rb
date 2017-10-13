# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RatsController, type: :controller do
  let(:rat) { create(:rat) }
  describe 'GET #show' do
    it 'returns http success' do
      get :show, params: { id: rat.id }
      expect(response).to have_http_status(:success)
    end
  end
end
