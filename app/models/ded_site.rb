# frozen_string_literal: true

class DedSite
  include MongoidSetup
  field :name, type: String
  field :level, type: String
  field :boss_ids_array, type: Array
  belongs_to :faction
  has_many :bosses, class_name: 'Rat'

  def boss_id
    attributes['boss_id']
  end

  def assign_boss_ids
    self.boss_ids_array = [boss_id] if boss_id
    save
  end

  def assign_bosses
    return unless boss_ids_array
    boss_ids_array.each do |boss_id|
      bosses << Rat.find(boss_id)
    end
    save
  end

  def yaml_attributes
    {
      id: id.to_s,
      name: name,
      level: level,
      boss_ids_array: boss_ids_array,
      faction_id: faction_id
    }
  end
end
