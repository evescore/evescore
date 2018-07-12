# frozen_string_literal: true

namespace :seeds do
  desc 'Delete Seed Data'
  task delete: :environment do
    exit unless user
    chars.each do |char|
      c = Character.where(id: char['_id']).first
      next unless c
      c.wallet_records.delete_all
      c.kills.delete_all
      c.destroy
    end
    User.where(email: 'foo@bar.com').delete_all
  end

  desc 'Load Seed Data'
  task load: :environment do
    User.where(email: 'foo@bar.com', password: 'qwerty').first_or_create
    chars.each do |char|
      Character.where(id: char['_id']).first || Character.create(char)
    end
    Character.where(:id.in => [2_113_331_370, 93_051_887, 93_131_435, 93_273_990, 94_534_434]).each do |character|
      rand(1..50).times do
        ts = Time.now - (rand 10_000_000)
        boss = DedSite.all.reject { |d| d.bosses.empty? }.map(&:bosses).map(&:first).select(&:faction_id).sample
        rats = Rat.where(:id.in => Rat.with_bounty.where(faction_id: boss.faction_id).map(&:id).sample(rand(1..5))).to_a
        rats.push(boss)
        amount = rand 100_000_000
        date = ts.to_date
        wallet_record = character.wallet_records.create(tax: 0.1 * amount, date: date, amount: amount, ts: ts, type: 'bounty_prizes', ded_site_id: boss.ded_site.id)
        rats.each do |rat|
          wallet_record.kills.create(character_id: character.id, rat_id: rat.id, amount: rand(1..5))
        end
      end
      rand(1..50).times do
        ts = Time.now - (rand 10_000_000)
        rats = Rat.where(:id.in => Rat.with_bounty.map(&:id).sample(rand(1..5)))
        amount = rand 100_000_000
        date = ts.to_date
        wallet_record = character.wallet_records.create(tax: 0.1 * amount, date: date, amount: amount, ts: ts, type: 'bounty_prizes')
        rats.each do |rat|
          wallet_record.kills.create(character_id: character.id, rat_id: rat.id, amount: rand(1..5))
        end
      end
      rand(1..50).times do
        ts = Time.now - (rand 10_000_000)
        agent = Agent.all.sample
        amount = rand 10_000_000
        date = ts.to_date
        character.wallet_records.create(tax: 0.1 * amount, date: date, amount: amount, ts: ts, type: 'agent_mission_reward', agent_id: agent.id, mission_level: rand(1..5))
      end
    end
  end
end

def user
  User.where(email: 'foo@bar.com').first
end

def chars
  [{ '_id' => 2_113_331_370,
     'user_id' => user.id,
     'name' => 'EVESCORE Test Character',
     'corporation_id' => 1_000_044,
     'alliance_id' => nil,
     'display_option' => 'Public' },
   { '_id' => 93_051_887,
     'user_id' => user.id,
     'name' => 'Blondie Blond',
     'corporation_id' => 98_279_136,
     'alliance_id' => nil,
     'display_option' => 'Public' },
   { '_id' => 93_131_435,
     'user_id' => user.id,
     'name' => 'Lei Chang',
     'corporation_id' => 1_000_114,
     'alliance_id' => nil,
     'display_option' => 'Public' },
   { '_id' => 93_273_990,
     'user_id' => user.id,
     'name' => 'Carl Malus',
     'corporation_id' => 1_000_009,
     'alliance_id' => nil,
     'display_option' => 'Public' },
   { '_id' => 94_534_434,
     'user_id' => user.id,
     'name' => 'EVESCORE',
     'corporation_id' => 98_305_855,
     'alliance_id' => nil,
     'display_option' => 'Public' }]
end
