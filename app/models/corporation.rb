# frozen_string_literal: true

class Corporation
  include MongoidSetup
  field :name, type: String
  field :npc, type: Boolean
  field :ticker, type: String
  field :characters_count, type: Integer, default: 0
  belongs_to :alliance, optional: true
  has_many :characters
  has_many :agents
  has_many :wallet_records
  after_save :create_alliance

  def self.update_counter_caches
    all.each do |user|
      user.characters_count = user.characters.count
      user.save
    end
  end

  def self.create_from_api(corporation_id)
    api_corporation = ESI::CorporationApi.new.get_corporations_corporation_id(corporation_id)
    where(id: corporation_id, name: api_corporation.name, ticker: api_corporation.ticker, alliance_id: api_corporation.alliance_id).first_or_create
  end

  def private?
    characters.map(&:display_option).uniq == ['Private']
  end

  def create_alliance
    return false unless alliance_id
    Alliance.create_from_api(alliance_id)
  end
end
