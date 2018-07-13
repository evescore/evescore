# frozen_string_literal: true

class Alliance
  include MongoidSetup
  field :name, type: String
  field :ticker, type: String
  field :characters_count, type: Integer, default: 0
  has_many :corporations
  has_many :characters

  def self.update_counter_caches
    all.each do |user|
      user.characters_count = user.characters.count
      user.save
    end
  end

  def self.create_from_api(alliance_id)
    api_alliance = ESI::AllianceApi.new.get_alliances_alliance_id(alliance_id)
    where(id: alliance_id, name: api_alliance.name, ticker: api_alliance.ticker).first_or_create
  end
end
