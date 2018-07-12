desc 'Seed Data'
task seed: :environment do
  Character.where(:id.in => [2113331370, 93051887, 93131435, 93273990, 94534434]).each do |character|
    (rand(50) + 1).times do
      ts = Time.now - (rand 10000000)
      boss = DedSite.all.select { |d| !d.bosses.empty? }.map(&:bosses).map(&:first).select { |b| b.faction_id }.sample
      rats = Rat.where(:id.in => Rat.with_bounty.where(faction_id: boss.faction_id).map(&:id).sample(rand(5) + 1)).to_a
      rats.push(boss)
      amount = rand 100000000
      date = ts.to_date
      wallet_record = character.wallet_records.create(date: date, amount: amount, ts: ts, type: 'bounty_prizes', ded_site_id: boss.ded_site.id)
      rats.each do |rat|
        wallet_record.kills.create(character_id: character.id, rat_id: rat.id, amount: rand(5) + 1)
      end
    end
    (rand(50) + 1).times do
      ts = Time.now - (rand 10000000)
      rats = Rat.where(:id.in => Rat.with_bounty.map(&:id).sample(rand(5) + 1))
      amount = rand 100000000
      date = ts.to_date
      wallet_record = character.wallet_records.create(date: date, amount: amount, ts: ts, type: 'bounty_prizes')
      rats.each do |rat|
        wallet_record.kills.create(character_id: character.id, rat_id: rat.id, amount: rand(5) + 1)
      end
    end
    (rand(50) +1).times do
      ts = Time.now - (rand 10000000)
      agent = Agent.all.sample
      amount = rand 10000000
      date = ts.to_date
      wallet_record = character.wallet_records.create(date: date, amount: amount, ts: ts, type: 'agent_mission_reward', agent_id: agent.id, mission_level: rand(5) + 1)
    end
  end
end