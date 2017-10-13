# frozen_string_literal: true

require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ApplicationHelper. For example:
#
# describe ApplicationHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ApplicationHelper, type: :helper do
  describe '#flash_to_alert' do
    it 'creates a div.alert with correct class' do
      flash = %w[error error]
      output = helper.flash_to_alert(flash)
      expect(output).to eq('<div class="alert alert-dismissible alert-danger"><button type="button" class="close" data-dismiss="alert">×</button>error</div>')
      flash = %w[warn warn]
      output = helper.flash_to_alert(flash)
      expect(output).to eq('<div class="alert alert-dismissible alert-warning"><button type="button" class="close" data-dismiss="alert">×</button>warn</div>')
    end
  end

  describe '#ded_site?' do
    it 'displays DED site info' do
      create(:rat)
      expect(helper.ded_site?(build(:ded_site))).to eq('&nbsp;<span class="label label-danger cursor-hand" data-toggle="tooltip" data-placement="top" title="The Maze">DED 10/10</span>')
    end
  end
end
