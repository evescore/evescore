# frozen_string_literal: true

module RatsHelper
  HP_PRESENTERS = %i[hp armor_hp shield_capacity].freeze

  HP_PRESENTERS.each do |method_name|
    define_method(method_name) do
      begin
        icon_tag(method_name.to_s, @attributes.send(method_name).display_name) + @attributes.send(method_name).presented_value
      rescue StandardError
        '-'
      end
    end
  end

  def repair(type)
    icon = icon_tag(type.to_s, "#{type.to_s.titleize} Per Second")
    rep = @attributes.repair_value(type)
    icon + number_with_precision(rep, precision: 2, delimiter: ',') + ' HP/s'
  rescue StandardError
    icon + '-'
  end

  def resistance_value(type, flavour)
    number_with_delimiter((100 - @attributes.send("#{flavour}_#{type}_damage_resonance").value * 100).to_i) + ' %'
  rescue StandardError
    '0 %'
  end

  def turret_damage(type)
    number_with_precision((@attributes.send("#{type}_damage").value * @attributes.damage_multiplier.value / (@attributes.speed.value / 1000)), precision: 2, delimiter: ',')
  rescue StandardError
    '-'
  end

  def missile_damage(type)
    begin
      multiplier = @attributes.missile_damage_multiplier.value
    rescue StandardError
      multiplier = 1
    end
    number_with_precision((@missile_attributes.send("#{type}_damage").value * multiplier / (@attributes.missile_launch_duration.value / 1000)), precision: 2, delimiter: ',')
  rescue StandardError
    '-'
  end

  def total_turret_damage
    total = @attributes.summarize_damage * @attributes.damage_multiplier.value / (@attributes.speed.value / 1000)
    icon_tag('turret', 'Turret DPS') + number_with_precision(total, precision: 2, delimiter: ',')
  rescue StandardError
    icon_tag('turret', 'Turret DPS') + '-'
  end

  def total_missile_damage
    begin
      multiplier = @attributes.missile_damage_multiplier.value
    rescue StandardError
      multiplier = 1
    end
    total = @missile_attributes.summarize_damage / (@attributes.missile_launch_duration.value / 1000) * multiplier
    icon_tag('missile_launcher', 'Missle DPS') + ' ' + number_with_precision(total, precision: 2, delimiter: ',')
  rescue StandardError
    icon_tag('missile_launcher', 'Missle DPS') + '-'
  end

  def damage_type(type, flavour)
    icon_tag("#{type}_#{flavour}", "#{type.to_s.capitalize} #{flavour.to_s.capitalize}")
  rescue StandardError
    ''
  end

  def other_effects(opts)
    text = +"<strong><em>#{opts[:title]}</em></strong><br>"
    opts[:attributes].each do |attribute|
      text << "<strong>#{attribute[:name]}:</strong> #{attribute[:value]} #{attribute[:unit]}<br>"
    end
    icon_tag(opts[:icon], text)
  rescue StandardError
    ''
  end

  EFFECT_PRESENT_HELPERS = %i[web neut scram ecm].freeze

  EFFECT_PRESENT_HELPERS.each do |method_name|
    define_method(method_name) do
      begin
        other_effects @attributes.send(method_name)
      rescue StandardError
        ''
      end
    end
  end

  SIMPLE_PRESENT_HELPERS = %i[
    max_velocity entity_cruise_speed entity_fly_range max_range signature_radius optimal_sig_radius
    max_locked_targets max_attack_targets ai_ignore_drones_below_signature_radius entity_kill_bounty
  ].freeze

  SIMPLE_PRESENT_HELPERS.each do |method_name|
    define_method(method_name) do
      begin
        @attributes.send(method_name).presented_value
      rescue StandardError
        '-'
      end
    end
  end
end
