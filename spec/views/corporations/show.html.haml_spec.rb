require 'rails_helper'

RSpec.describe "corporations/show", type: :view do
  before(:each) do
    @corporation = assign(:corporation, Corporation.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
