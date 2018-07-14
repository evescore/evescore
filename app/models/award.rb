# frozen_string_literal: true

class Award
  include Mongoid::Document
  field :name, type: String
  field :type, type: String
  field :short_name, type: String
  field :category, type: String
  field :tier, type: Integer
  field :description, type: String
  field :icon, type: String

  validates :name, uniqueness: { scope: %i[category tier] }

  def self.grouped
    all.to_a.group_by(&:category).sort
  end
end
