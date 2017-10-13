# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rat, type: :model do
  before(:each) do
    @faction = create(:faction)
    @rat = create(:rat)
  end

  context '#type_api' do
    it 'returns ESI object' do
      expect(@rat.types_api).to be_an(ESI::GetUniverseTypesTypeIdOk)
    end
  end

  context '#set_faction' do
    it 'sets faction' do
      expect { @rat.set_faction }.not_to raise_error
      expect(@rat.faction_id).to eq(@faction.id)
    end
  end

  context '#rat_attributes' do
    it 'returns rat attributes' do
      expect(@rat.rat_attributes).to be_an(Array)
    end
  end
end
