# frozen_string_literal: true

class AwardService
  attr_accessor :character
  attr_accessor :award

  def initialize(character, award)
    @character = character
    @award = award
  end

  def check
    return true if character.award?(award.id)
    (call_award_method && grant_award) || false
  end

  def call_award_method
    send(award.short_name.to_sym)
  end

  def grant_award
    character.character_awards.create(award_id: award.id) && true
  end

  def rat_amount1
    @character.kills.sum(:amount) >= 10_000
  end

  def rat_amount2
    @character.kills.sum(:amount) >= 25_000
  end

  def rat_amount3
    @character.kills.sum(:amount) >= 50_000
  end

  def rat_amount4
    @character.kills.sum(:amount) >= 100_000
  end

  def isk_amount1
    @character.wallet_records.sum(:amount) >= 1_000_000_000
  end

  def isk_amount2
    @character.wallet_records.sum(:amount) >= 2_500_000_000
  end

  def isk_amount3
    @character.wallet_records.sum(:amount) >= 5_000_000_000
  end

  def isk_amount4
    @character.wallet_records.sum(:amount) >= 10_000_000_000
  end

  def isk_amount5
    @character.wallet_records.sum(:amount) >= 25_000_000_000
  end

  def isk_amount6
    @character.wallet_records.sum(:amount) >= 50_000_000_000
  end

  def faction_sansha
    @character.faction_rat_kills(500_019).count.positive?
  end

  def faction_guristas
    @character.faction_rat_kills(500_010).count.positive?
  end

  def faction_blood_raiders
    @character.faction_rat_kills(500_012).count.positive?
  end

  def faction_serpentis
    @character.faction_rat_kills(500_020).count.positive?
  end

  def faction_angel_cartel
    @character.faction_rat_kills(500_011).count.positive?
  end

  def faction_all
    @character.awards.select { |a| a.category == 'factions' }.count >= 5
  end

  def capitals_dreadnought
    match = ['Angel Dreadnought', 'Blood Dreadnought', 'Guristas Dreadnought', "Sansha's Dreadnought", 'Serpentis Dreadnought']
    @character.kills.where(:rat_id.in => Rat.where(:name.in => match).map(&:id)).count.positive?
  end

  def capitals_faction_dreadnought
    match = ['Domination Dreadnought', 'Dark Blood Dreadnought', 'Dread Guristas Dreadnought', "True Sansha's Dreadnought", 'Shadow Serpentis Dreadnought']
    @character.kills.where(:rat_id.in => Rat.where(:name.in => match).map(&:id)).count.positive?
  end

  def capitals_titan
    match = ['Domination Titan', 'Dark Blood Titan', 'Dread Guristas Titan', 'Shadow Serpentis Titan']
    @character.kills.where(:rat_id.in => Rat.where(:name.in => match).map(&:id)).count.positive?
  end

  def rat_hauler
    match = ['Asteroid Angel Cartel Hauler', 'Asteroid Blood Raiders Hauler', 'Asteroid Guristas Hauler', "Asteroid Sansha's Nation Hauler", 'Asteroid Serpentis Hauler', 'Asteroid Rogue Drone Hauler']
    rat_ids = Rat.where(:group_id.in => Group.where(:name.in => match).map(&:id)).map(&:id)
    @character.kills.where(:rat_id.in => rat_ids).count.positive?
  end
end
