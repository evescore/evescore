# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Corporation, type: :model do
  context 'create_alliance' do
    it 'creates alliance from API' do
      expect { Corporation.new(alliance_id: 1_354_830_081).create_alliance }.not_to raise_error
    end
  end
end
