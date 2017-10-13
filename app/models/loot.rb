# frozen_string_literal: true

class Loot
  include Mongoid::Document
  include ApiAttributes
  field :name, type: String
  field :price, type: Float
  field :description, type: String
  has_and_belongs_to_many :rats

  scope :zero_price, -> { Loot.or(price: nil).or(price: 0) }

  alias loot_attributes api_attributes

  def self.ids
    @ids ||= all.map(&:id)
  end

  def self.assign_prices(progress = false)
    market_prices(progress).each do |row|
      item = where(id: row.type_id).first
      item&.update_attributes(price: row.average_price)
    end
    return if zero_price.empty?
    zeros = progress ? zero_price.tqdm(desc: 'Assigning additional Prices to loot', leave: true) : zero_price
    zeros.each(&:assign_price) && true
  end

  def self.assign_to_rats
    all.each do |loot|
      loot.rat_ids.each do |rat_id|
        rat = Rat.find(rat_id)
        rat.loot << loot
        rat.save
      end
    end
  end

  def check_price
    prices = ESI::MarketApi.new.get_markets_region_id_orders('sell', 10_000_002, type_id: id).map(&:price)
    prices.inject(&:+) / prices.size
  rescue StandardError
    0
  end

  def assign_price
    self.price = check_price
    save
  end

  def self.market_prices(progress = false)
    market_prices = ESI::MarketApi.new.get_markets_prices
    market_prices = market_prices.select { |m| Loot.ids.include? m.type_id }
    market_prices.tqdm(desc: 'Assigning Prices to Loot', leave: true) if progress
  end
end
