# frozen_string_literal: true

namespace :update do
  desc 'Update Rats'
  task rats: :environment do
    update_rats
  end
  desc 'Update Groups'
  task groups: :environment do
    update_groups
  end
end

def rat_ids
  Rat.all.map(&:id)
end

def group_ids
  Group.all.map(&:id)
end

def api_group_ids
  @api_group_ids ||= ESI::UniverseApi.new.get_universe_categories_category_id(11).groups
end

def api_rat_ids
  output = []
  api_group_ids.tqdm.each do |group_id|
    ESI::UniverseApi.new.get_universe_groups_group_id(group_id).types.each do |type_id|
      output.push type_id
    end
  end
  output
end

def update_groups
  new_ids = api_group_ids - group_ids
  return if new_ids.empty?
  puts "#{new_ids.size} new groups"
  new_ids.each do |id|
    group = Group.create(id: id)
    puts group.name
  end
end

def update_rats
  new_ids = api_rat_ids - rat_ids
  return if new_ids.empty?
  puts "#{new_ids.size} new rats"
  new_ids.each do |id|
    rat = Rat.create(id: id)
    puts rat.name
  end
end
