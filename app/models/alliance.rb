# frozen_string_literal: true

class Alliance
  include MongoidSetup
  field :name, type: String
  field :ticker, type: String
  has_many :corporations
  has_many :characters

  def self.create_from_api(alliance_id)
    api_alliance = ESI::AllianceApi.new.get_alliances_alliance_id(alliance_id)
    where(id: alliance_id, name: api_alliance.name, ticker: api_alliance.ticker).first_or_create
  end
end
