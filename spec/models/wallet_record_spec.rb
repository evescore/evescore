# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WalletRecord, type: :model do
  before(:all) do
    create(:faction)
    VCR.use_cassette(:esi, record: :new_episodes) do
      @rat = create(:rat)
    end
    create(:ded_site)
  end

  context '#check_ded_site_id' do
    it 'checks DED site id' do
      expect { WalletRecord.new.check_ded_site_id(@rat.id) }.not_to raise_error
    end
  end
end
