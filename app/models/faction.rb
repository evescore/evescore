# frozen_string_literal: true

class Faction
  include Mongoid::Document
  field :name, type: String
  field :pattern, type: Regexp
  field :has_rats, type: Boolean
  validates :name, uniqueness: true
  belongs_to :corporation, optional: true
  has_many :rats
  has_many :groups
  has_many :ded_sites

  scope :legit, -> { where(has_rats: true) }
  scope :ded_sites, -> { where(:id.in => [500_010, 500_011, 500_012, 500_019, 500_020]) }

  attr_accessor :ded_level

  SIZES = {
    500_010 => {
      frigate: { prefix: 'Pithi', ship: 'Worm' },
      cruiser: { prefix: 'Pithum', ship: 'Gila' },
      battleship: { prefix: 'Pith', ship: 'Rattlesnake' }
    },
    500_011 => {
      frigate: { prefix: 'Gistii', ship: 'Dramiel' },
      cruiser: { prefix: 'Gistum', ship: 'Cynabal' },
      battleship: { prefix: 'Gist', ship: 'Machariel' }
    },
    500_012 => {
      frigate: { prefix: 'Corpii', ship: 'Cruor' },
      cruiser: { prefix: 'Corpum', ship: 'Ashimmu' },
      battleship: { prefix: 'Corpus', ship: 'Bhaalgorn' }
    },
    500_019 => {
      frigate: { prefix: 'Centii', ship: 'Succubus' },
      cruiser: { prefix: 'Centum', ship: 'Phantasm' },
      battleship: { prefix: 'Centus', ship: 'Nightmare' }
    },
    500_020 => {
      frigate: { prefix: 'Coreli', ship: 'Daredevil' },
      cruiser: { prefix: 'Corelum', ship: 'Vigilant' },
      battleship: { prefix: 'Core', ship: 'Vindicator' }
    }
  }.freeze

  TYPES = {
    1 => { size: :frigate, type: :c, overseer: 3 },
    2 => { size: :frigate, type: :b, overseer: 6 },
    3 => { size: :frigate, type: :a, overseer: 7 },
    4 => { size: :cruiser, type: :c, overseer: 8 },
    5 => { size: :cruiser, type: :b, overseer: 18 },
    6 => { size: :cruiser, type: :a, overseer: 19 },
    7 => { size: :battleship, type: :c, overseer: 20 },
    8 => { size: :battleship, type: :b, overseer: 21 },
    9 => { size: :battleship, type: :a, overseer: 22 },
    10 => { size: :battleship, type: :x, overseer: 23 }
  }.freeze

  def self.detect(string)
    all.each do |faction|
      next if faction.pattern.nil?
      return faction if faction.pattern.compile.match?(string)
    end
    nil
  end

  def ded_site_loot
    return false unless ded_level
    Type.where(name: loot_pattern).each do |item|
      Loot.where(id: item.id, name: item.name, description: item.description).first_or_create
    end
    Loot.where(name: loot_pattern)
  end

  def assign_loot_to_bosses
    ded_sites.each do |ded_site|
      self.ded_level = ded_site.level.gsub(%r{/10$}, '').to_i
      loot = ded_site_loot
      next unless loot
      ded_site.bosses.first.loot = loot.to_a if ded_site.bosses.count == 1
    end
  end

  private

  def effects
    "#{TYPES[ded_level][:overseer].ordinalize} Tier Overseer's Personal Effects"
  end

  def prefix
    SIZES[id][TYPES[ded_level][:size]][:prefix]
  end

  def type
    "#{TYPES[ded_level][:type].upcase}-Type"
  end

  def modules
    /^#{prefix} #{type}/
  end

  def blueprint
    "#{ship} Blueprint"
  end

  def loot_pattern
    ::Regexp.union([effects, modules, blueprint])
  end

  def ship
    SIZES[id][TYPES[ded_level][:size]][:ship]
  end
end
