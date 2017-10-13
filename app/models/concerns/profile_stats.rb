# frozen_string_literal: true

module ProfileStats
  extend ActiveSupport::Concern

  def earnings_by_day(limit = nil)
    query = wallet_records.group(_id: '$date', :amount.sum => '$amount')
                          .desc(:_id)
                          .project(_id: 0, date: '$_id', amount: 1)
    pipeline = query.pipeline
    pipeline.push('$limit' => limit) if limit
    WalletRecord.collection.aggregate pipeline
  end

  def missions_by_level(limit = nil)
    query = wallet_records.missions.group(_id: '$mission_level', :amount.sum => 1)
                          .project(_id: 0, level: '$_id', amount: 1)
                          .desc(:amount)
    pipeline = query.pipeline
    pipeline.push('$limit' => limit) if limit
    WalletRecord.collection.aggregate pipeline
  end

  def ded_sites_by_site(limit = nil)
    query = wallet_records.ded_sites.group(_id: '$ded_site_id', :amount.sum => 1)
    pipeline = query.pipeline
    pipeline += [
      { '$lookup' => { from: 'ded_sites', localField: '_id', foreignField: '_id', as: 'ded_site' } },
      { '$project' => { _id: 1, amount: 1, ded_site: { '$arrayElemAt' => ['$ded_site', 0] } } },
      { '$project' => { _id: 0, amount: 1, name: '$ded_site.name', level: '$ded_site.level', ded_faction_id: '$ded_site.faction_id' } },
      { '$sort' => { 'amount' => -1 } }
    ]
    pipeline.push('$limit' => limit) if limit
    WalletRecord.collection.aggregate pipeline
  end

  def kills_by_bounty(limit = nil)
    query = kills.group(_id: { rat_id: '$rat_id', bounty: '$bounty' }, :amount.sum => '$amount')
    pipeline = query.pipeline
    pipeline += [
      { '$lookup' => { from: 'rats', localField: '_id.rat_id', foreignField: '_id', as: 'rat' } },
      { '$project' => { _id: 1, amount: 1, rat: { '$arrayElemAt' => ['$rat', 0] } } },
      { '$project' => { _id: 0, amount: 1, rat_id: '$_id.rat_id', bounty: '$_id.bounty', name: '$rat.name', group: '$rat.group' } },
      { '$sort' => { 'bounty' => -1 } }
    ]
    pipeline.push('$limit' => limit) if limit
    Kill.collection.aggregate pipeline
  end

  def kills_by_faction(limit = nil)
    query = kills.group(_id: '$faction_id', :amount.sum => '$amount')
    pipeline = query.pipeline
    pipeline += [
      { '$lookup' => { from: 'factions', localField: '_id', foreignField: '_id', as: 'faction' } },
      { '$project' => { _id: 1, amount: 1, faction: { '$arrayElemAt' => ['$faction', 0] } } },
      { '$project' => { _id: 0, amount: 1, name: '$faction.name', corporation_id: '$faction.corporation_id' } },
      { '$sort' => { amount: -1 } }
    ]
    pipeline.push('$limit' => limit) if limit
    Kill.collection.aggregate pipeline
  end

  def average_tick
    wallet_records.sum(:amount) / wallet_records.count
  rescue ZeroDivisionError
    0
  end

  def total_isk
    wallet_records.sum(:amount)
  end

  def total_kills
    kills.sum(:amount)
  end

  def favourite_faction
    kills_by_faction.first || OpenStruct.new
  end

  def favourite_ded_site
    ded_sites_by_site.first || {}
  end

  def favourite_mission_level
    missions_by_level.first.try(:[], 'level')
  end

  def ded_sites_run
    wallet_records.where(:ded_site.ne => nil).count
  end

  def missions_run
    wallet_records.where(:mission_level.ne => nil).count
  end
end
