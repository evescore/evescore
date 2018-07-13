require 'rails_helper'

RSpec.describe "corporations/index", type: :view do
  before(:each) do
    assign(:corporations, [
      Corporation.create!(),
      Corporation.create!()
    ])
  end

  it "renders a list of corporations" do
    render
  end
end
