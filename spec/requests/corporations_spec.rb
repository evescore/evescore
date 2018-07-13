require 'rails_helper'

RSpec.describe "Corporations", type: :request do
  describe "GET /corporations" do
    it "works! (now write some real specs)" do
      get corporations_path
      expect(response).to have_http_status(200)
    end
  end
end
