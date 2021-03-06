# frozen_string_literal: true

class Character
  include MongoidSetup
  include EsiCharacterApi
  include ProfileStats
  field :name, type: String
  field :access_token, type: String
  field :refresh_token, type: String
  field :token_expires, type: Time
  field :display_option, type: String
  belongs_to :corporation, optional: true, counter_cache: true
  belongs_to :alliance, optional: true, counter_cache: true
  belongs_to :user, counter_cache: true
  has_many :wallet_records
  has_many :kills
  has_many :character_awards

  scope :public_characters, -> { where(display_option: 'Public') }
  scope :without_test, -> { where(:id.nin => TEST_CHARS) }

  after_save :create_corporation
  after_create :queue_initial_import

  def award?(award_id)
    character_awards.where(award_id: award_id).first || false
  end

  def awards
    character_awards.map(&:award)
  end

  def queue_initial_import
    CharacterWalletImportJob.perform_later(self)
  end

  def create_corporation
    Corporation.create_from_api(corporation_id)
  end

  def wallet_journal
    wallet_api.get_characters_character_id_wallet_journal(id)
  end

  def import_wallet
    wallet_journal.select { |r| WalletRecord.importable?(r.ref_type) }.each do |wallet_record|
      WalletRecord.create_from_api(id, user_id, wallet_record)
    end
  end

  def grant_awards
    Award.all.each do |award|
      AwardService.new(self, award).check
    end
  end

  def faction_rat_kills(faction_id)
    kills.where(:rat_id.in => Rat.where(:group_id.in => Faction.find(faction_id).groups.where(name: /Commander/).map(&:id)).map(&:id))
  end
end
