# frozen_string_literal: true

class Kill
  include Mongoid::Document
  include TopAggregations
  field :ts, type: Time
  field :date, type: Date
  field :amount, type: Integer
  field :bounty, type: Float
  belongs_to :wallet_record
  belongs_to :rat, optional: true
  belongs_to :faction, optional: true
  belongs_to :user, optional: true
  after_create :create_rat
  belongs_to :character

  delegate :name, to: :rat

  def create_rat
    rat = Rat.where(id: rat_id).first_or_create
    update_attributes(bounty: rat.bounty) if bounty.nil?
    update_attributes(faction_id: rat.faction_id) if faction_id.nil?
  end

  def self.public_top(limit = nil)
    query = public_records.group(_id: '$character_id', :amount.sum => '$amount').desc(:amount)
    aggregate_public_top_pipeline(query, limit)
  end
end
