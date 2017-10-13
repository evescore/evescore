# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FactionsController, type: :controller do
  describe 'GET #index' do
    it 'returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #groups' do
    it 'returns http success' do
      get :groups, params: { group_id: 495 }
      expect(response).to have_http_status(:success)
    end
  end
end
