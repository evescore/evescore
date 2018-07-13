# frozen_string_literal: true

class Rat
  include MongoidSetup
  include ApiAttributes
  field :name, type: String
  field :bounty, type: Float
  has_and_belongs_to_many :loot, class_name: 'Loot'
  has_many :kills
  belongs_to :faction, optional: true
  belongs_to :group, optional: true
  belongs_to :ded_site, optional: true

  before_save :details_from_api, :set_faction, unless: :just_save

  scope :with_bounty, -> { where(:bounty.ne => nil).where(:bounty.gt => 0) }

  alias rat_attributes api_attributes

  attr_accessor :just_save

  def assign_bounty
    self.bounty = begin
                    api_object.dogma_attributes.select { |a| a.attribute_id == 481 }.first.try(:value)
                  rescue StandardError
                    nil
                  end
  end

  def update_bounty
    assign_bounty
    save
  end

  def details_from_api
    assign_bounty
    self.name = api_object.name
    self.group_id = api_object.group_id
  end

  def description
    types_api.description
  end

  def set_faction
    faction = Faction.detect(group.name) || Faction.detect(name)
    return false unless faction
    self.faction_id = faction.id
  end

  def structure_hitpoints
    rat_attributes.select { |a| a.id == 9 }[0]
  end

  private

  def api_object
    @api_object ||= ESI::UniverseApi.new.get_universe_types_type_id(id)
  end
end
