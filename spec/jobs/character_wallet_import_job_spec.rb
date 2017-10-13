# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CharacterWalletImportJob, type: :job do
  let(:user) { create(:user) }
  let(:character) { create(:character, user_id: user.id) }
  it 'performs character wallet import' do
    expect { CharacterWalletImportJob.perform_now(character) }.not_to raise_error
  end
end
