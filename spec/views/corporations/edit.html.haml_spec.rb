require 'rails_helper'

RSpec.describe "corporations/edit", type: :view do
  before(:each) do
    @corporation = assign(:corporation, Corporation.create!())
  end

  it "renders the edit corporation form" do
    render

    assert_select "form[action=?][method=?]", corporation_path(@corporation), "post" do
    end
  end
end
