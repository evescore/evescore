require 'rails_helper'

RSpec.describe "corporations/new", type: :view do
  before(:each) do
    assign(:corporation, Corporation.new())
  end

  it "renders new corporation form" do
    render

    assert_select "form[action=?][method=?]", corporations_path, "post" do
    end
  end
end
