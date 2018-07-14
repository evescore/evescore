# frozen_string_literal: true

namespace :import do
  desc 'Import all EVE SDE and API data'
  task all: :environment do
    import_all
  end
  desc 'Import NPC corporations from EVE SDE and API data'
  task corps: :environment do
    create_corps
  end
  desc 'Perform WalletRecord import from ESI'
  task wallets: :environment do
    import_wallets
  end
  desc 'Import NPC Factions from EVE SDE and API data'
  task factions: :environment do
    create_factions
  end
  desc 'Import DED Sites'
  task ded_sites: :environment do
    create_ded_sites
  end
  desc 'Import Dogma Attribute Types'
  task dogma_attribute_types: :environment do
    create_dogma_attribute_types
  end
  desc 'Import Charges'
  task charges: :environment do
    create_charges
  end
  desc 'Import Rats'
  task rats: :environment do
    create_rats
  end
  desc 'Import Groups'
  task groups: :environment do
    create_groups
  end
  desc 'Import Types'
  task types: :environment do
    create_types
  end
  desc 'Import Loot'
  task loot: :environment do
    assign_loot
  end
  desc 'Import Loot Prices'
  task prices: :environment do
    assign_prices
  end
end

def logger
  Logger.new(STDOUT)
end

def import_all
  create_charges
  create_corps
  create_agents
  create_factions
  create_dogma_attribute_types
  create_types
  create_rats
  create_ded_sites
  assign_loot
  assign_prices
end

def create_types
  Type.delete_all
  YAML.load_file('data/types.yml').tqdm(leave: true, desc: 'Importing Types').each do |type|
    Type.create(type)
  end
end

def create_groups
  Group.delete_all
  YAML.load_file('data/groups.yml').tqdm(leave: true, desc: 'Importing Groups').each do |type|
    Group.create(type)
  end
end

def create_rats
  create_groups
  Rat.delete_all
  rats = YAML.load_file('data/rats.yml')
  rats.tqdm(leave: true, desc: 'Importing Rats').each do |rat|
    r = Rat.new(rat)
    r.just_save = true
    r.save
  end
  # Type.where(:group_id.in => Group.all.map(&:id)).tqdm(leave: true, desc: 'Importing Rats').each(&:create_rat)
end

def create_charges
  Charge.delete_all
  charges = YAML.load_file('data/charges.yml')
  charges.tqdm(leave: true, desc: 'Importing Charges').each do |charge|
    Charge.create(charge)
  end
end

def create_dogma_attribute_types
  DogmaAttributeType.delete_all
  dogma_attribute_types = YAML.load_file('data/dogma_attribute_types.yml')
  dogma_attribute_types.tqdm(leave: true, desc: 'Importing Dogma Attribute Types').each do |dogma_attribute_type|
    DogmaAttributeType.create(dogma_attribute_type)
  end
end

def create_agents
  Agent.delete_all
  agents = YAML.load_file('data/agents.yml')
  agents.tqdm(leave: true, desc: 'Importing Mission Agents').each do |agent|
    Agent.create(agent)
  end
end

def create_corps
  Corporation.where(npc: true).delete_all
  corps = YAML.load_file('data/corporations.yml')
  corps.tqdm(leave: true, desc: 'Importing NPC Corporations').each do |corp|
    c = Corporation.new(corp)
    c.npc = true
    c.save
  end
end

def create_factions
  Faction.delete_all
  factions = YAML.load_file('data/factions.yml')
  factions.tqdm(leave: true, desc: 'Importing Factions').each do |faction|
    f = Faction.new(faction)
    f.has_rats = true
    f.save
  end
end

def create_ded_sites
  DedSite.delete_all
  ded_sites = YAML.load_file('data/ded_sites.yml')
  ded_sites.tqdm(leave: true, desc: 'Importing DED Sites').each do |ded_site|
    d = DedSite.create(ded_site)
    d.assign_bosses
  end
end

def import_wallets
  User.all.each do |user|
    user.characters.without_test.each do |character|
      import_wallet(character)
    end
  end
end

def import_wallet(character)
  start = Time.now.to_f
  logger.info "Starting import for: #{character.id}"
  character.import_wallet
  logger.info "Finished import for: #{character.id}, took: #{format '%.2f', Time.now.to_f - start} seconds"
end

def assign_loot
  Faction.all.each(&:assign_loot_to_bosses)
end

def assign_prices
  Loot.assign_prices(true)
end
