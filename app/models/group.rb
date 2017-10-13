# frozen_string_literal: true

class Group
  include Mongoid::Document
  field :name, type: String
  has_many :rats
  has_many :types
  belongs_to :faction, optional: true
end
