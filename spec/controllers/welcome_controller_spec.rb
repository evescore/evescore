# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do
  describe 'average_ticks' do
    it 'assigns @top_average_ticks' do
      get :average_ticks
      expect(response.status).to eq(200)
    end
  end

  describe 'isk' do
    it 'assigns @top_isk' do
      get :isk
      expect(response.status).to eq(200)
    end
  end
end
