# frozen_string_literal: true

module ImageHelper
  def icon_tag(icon, tooltip = nil)
    image_tag("#{icon}.png", { style: 'height: 32px' }.merge(tooltip(tooltip)))
  end

  def navbar_portrait(character)
    title = character.name
    character_image(character.id, 32, tooltip(title))
  end

  def character_image(character_id, size = 64, options = {})
    options[:class] = 'img-rounded portrait'
    image_tag "https://image.eveonline.com/Character/#{character_id}_#{size}.jpg", options
  end

  def type_image(type_id, size = 32, options = { highligh_ded_boss: true })
    # ded_boss = DedSite.all.map(&:boss_id).include?(type_id) if options[:highligh_ded_boss]
    options[:class] = 'img-rounded cursor-hand'
    # options[:style] = 'border: 1px solid; border-color: red' if ded_boss
    image_tag("https://image.eveonline.com/Type/#{type_id}_#{size}.png", options)
  end

  def type_image_path(type_id, size = 32)
    "https://image.eveonline.com/Type/#{type_id}_#{size}.png"
  end

  def kill_image(kill)
    kill = OpenStruct.new(kill) if kill.class == BSON::Document
    title = "<strong>#{kill.name}</strong><br>#{kill.amount} kills"
    link_to type_image(kill.rat_id, 32, tooltip(title)), rats_path(kill.rat_id)
  rescue ActionView::Template::Error
    ''
  end

  def isk_image
    type_image(29, 32)
  end

  def alliance_image(alliance_id, size = 32, options = {})
    options[:class] = 'img-rounded'
    image_tag("https://image.eveonline.com/Alliance/#{alliance_id}_#{size}.png", options)
  end

  def corporation_image(corporation_id, size = 32, options = {})
    return '-' unless corporation_id
    options[:class] = 'img-rounded'
    image_tag("https://image.eveonline.com/Corporation/#{corporation_id}_#{size}.png", options)
  end

  def faction_image(faction_id, size = 32)
    return '' if faction_id.blank?
    faction = Faction.find(faction_id)
    image_tag("faction_#{faction_id}.png", { style: "height: #{size}px" }.merge(tooltip(faction.name)))
  end
end
