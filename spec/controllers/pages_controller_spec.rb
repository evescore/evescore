require 'rails_helper'

RSpec.describe PagesController, type: :controller do

  describe "GET #legal" do
    it "returns http success" do
      get :legal
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #stats" do
    it "returns http success" do
      get :stats
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #info" do
    it "returns http success" do
      get :info
      expect(response).to have_http_status(:success)
    end
  end

end
