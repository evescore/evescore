# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Pages', type: :feature do
  before(:each) do
    @user = create(:user)
    @character = create(:character, user_id: @user.id)
  end

  describe 'with wallet data' do
    before(:each) do
      create(:corporation, :corp1)
      create(:corporation, :corp2)
      create(:agent, :agent1)
      create(:agent, :agent2)

      @character.import_wallet
    end

    context 'Main page' do
      it 'should load w/o errors' do
        visit '/'
        expect(current_path).to eq('/')
      end
    end

    context 'Profile Page' do
      it 'should load w/o errors' do
        visit character_profile_path(@character)
        expect(current_path).to eq(character_profile_path(@character))
      end
    end

    context 'Ticks' do
      it 'should visit the ticks page' do
        visit global_ticks_path
        expect(current_path).to eq(global_ticks_path)
      end
    end

    context 'Character Earnings' do
      it 'should display character earnings page' do
        visit character_earnings_path(@character)
        expect(current_path).to eq(character_earnings_path(@character))
      end
    end

    context 'Character Ticks' do
      it 'should display character ticks page' do
        visit character_ticks_path(@character)
        expect(current_path).to eq(character_ticks_path(@character))
      end
    end

    context 'Character Rats' do
      it 'should display character rats page' do
        visit character_rats_path(@character)
        expect(current_path).to eq(character_rats_path(@character))
      end
    end

    context 'Character Journal' do
      it 'should display character journal page' do
        visit character_journal_path(@character)
        expect(current_path).to eq(character_journal_path(@character))
      end
    end
  end

  describe 'without wallet data' do
    context 'Profile Page' do
      it 'should load w/o errors' do
        visit character_profile_path(@character)
        expect(current_path).to eq(character_profile_path(@character))
      end
    end
  end
end
