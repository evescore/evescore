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
    send((award.short_name + award.tier.to_s).to_sym)
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
end
