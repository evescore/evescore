# frozen_string_literal: true

require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ImageHelper. For example:
#
# describe ImageHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ImageHelper, type: :helper do
  describe '#navbar_portrait' do
    let(:character) { build(:character) }
    it 'displays the navbar character portrait' do
      img = '<img data-toggle="tooltip" data-placement="top" title="Adrian Dent" class="img-rounded portrait" src="https://image.eveonline.com/Character/810699209_32.jpg" alt="810699209 32" />'
      expect(helper.navbar_portrait(character)).to eq(img)
    end
  end

  describe '#alliance_image' do
    it 'displays the alliance image' do
      img = '<img class="img-rounded" src="https://image.eveonline.com/Alliance/1354830081_32.png" alt="1354830081 32" />'
      expect(helper.alliance_image(1_354_830_081)).to eq(img)
    end
  end

  describe '#faction_image' do
    let(:corporation) { create(:corporation, :guristas) }
    let(:faction) { create(:faction, corporation_id: corporation.id) }
    it 'displays faction image' do
      expect { helper.faction_image(faction.id) }.not_to raise_error
    end
  end

  describe '#kill_image' do
    it 'handles an ActionView::Template::Error exception' do
      kill = double
      class ActionView::Template::Error
        def initialize; end
      end
      allow(kill).to receive(:name).and_raise(ActionView::Template::Error)
      expect(helper.kill_image(kill)).to be_empty
    end
  end
end
