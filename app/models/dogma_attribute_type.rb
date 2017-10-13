# frozen_string_literal: true

class DogmaAttributeType
  include Mongoid::Document
  field :attribute_name, type: String
  field :category_id, type: Integer
  field :default_value, type: Float
  field :description, type: String
  field :high_is_good, type: Boolean
  field :published, type: Boolean
  field :stackable, type: Boolean
  field :icon_id, type: Integer
  field :unit_id, type: Integer
  field :display_name, type: String

  def attribute_id=(value)
    self.id = value
  end
end
