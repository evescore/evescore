# frozen_string_literal: true

class Type
  include Mongoid::Document
  include ApiAttributes
  field :name, type: String
  field :description, type: String
  belongs_to :group, optional: true

  def assign_to_rat(rat)
    loot = Loot.where(id: id, name: name, description: description).first_or_create
    rat.loot << loot
  end

  def create_rat
    rat = Rat.new(id: id, name: name, group_id: group_id)
    rat.just_save = true
    rat.save
  end

  def create_loot
    Loot.create(id: id, name: name, description: description)
  end
end
