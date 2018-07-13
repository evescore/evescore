require "rails_helper"

RSpec.describe CorporationsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/corporations").to route_to("corporations#index")
    end

    it "routes to #new" do
      expect(:get => "/corporations/new").to route_to("corporations#new")
    end

    it "routes to #show" do
      expect(:get => "/corporations/1").to route_to("corporations#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/corporations/1/edit").to route_to("corporations#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/corporations").to route_to("corporations#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/corporations/1").to route_to("corporations#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/corporations/1").to route_to("corporations#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/corporations/1").to route_to("corporations#destroy", :id => "1")
    end

  end
end
