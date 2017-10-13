# frozen_string_literal: true

class Agent
  include Mongoid::Document
  field :name, type: String
  field :division, type: String
  field :level, type: Integer
  belongs_to :corporation
  has_many :wallet_records
end
