# frozen_string_literal: true

module ApplicationHelper
  def welcome_path
    if request.path == '/'
      url = URI.parse(request.url)
      url.host = url.host.gsub(/(rats|ratopedia|rat)\./, '')
      url.to_s
    else
      root_path
    end
  end

  def flash_to_alert(flash)
    case flash[0]
    when 'notice'
      html_class = 'info'
    when 'error', 'alert'
      html_class = 'danger'
    when 'warn'
      html_class = 'warning'
    end
    content_tag(:div, close_button('alert') + flash[1], class: "alert alert-dismissible alert-#{html_class}")
  end

  def close_button(type)
    "<button type=\"button\" class=\"close\" data-dismiss=\"#{type}\">×</button>".html_safe
  end

  def icon(name)
    content_tag(:span, '', class: "glyphicon glyphicon-#{name}")
  end

  def login_with_eve
    link_to image_tag('EVE_SSO_Login_Buttons_Small_Black.png'), user_esi_omniauth_authorize_path
  end

  def number_to_isk(amount)
    number_to_currency amount, format: '%n %u', precision: 0, unit: 'ISK'
  end

  def number_to_isk_short(amount)
    number_to_human amount, units: { unit: ' ISK', thousand: 'K ISK', million: 'M ISK', billion: 'b ISK' }, format: '%n%u'
  end

  def record_icon(record)
    case record.type
    when 'bounty_prizes'
      corporation_image(1_000_125, 32, tooltip('CONCORD'))
    when 'agent_mission_reward', 'agent_mission_time_bonus_reward'
      options = tooltip Corporation.find(record.agent.corporation_id).name
      corporation_image(record.agent.corporation_id, 32, options)
    end
  end

  def tooltip(title)
    { data: { toggle: 'tooltip', placement: 'top' }, title: title }
  end

  def mission_level_label(mission_level)
    classes = { 1 => 'success', 2 => 'info', 3 => 'warning', 4 => 'danger', 5 => 'purple' }
    text = mission_level ? "LEVEL #{mission_level}" : '-'
    html_class = mission_level ? "label label-#{classes[mission_level]}" : nil
    content_tag(:span, text, class: html_class)
  end

  def mission_label(agent, type = 'Mission')
    mission_level_label(agent.level) + '&nbsp;'.html_safe + content_tag(:span, "#{agent.division} #{type}", class: 'label label-primary')
  end

  def ded_site?(ded_site, options = {})
    return if ded_site.blank?
    ded_site = OpenStruct.new(ded_site) if ded_site.class == BSON::Document
    options[:class] = 'label label-danger cursor-hand'
    options.merge! tooltip(ded_site.name)
    '&nbsp;'.html_safe + content_tag(:span, "DED #{ded_site.level}", options)
  end

  def record_details(record)
    case record.type
    when 'bounty_prize'
      concat content_tag(:span, 'ESS', class: 'label label-warn')
    when 'bounty_prizes'
      concat content_tag(:span, 'Bounty', class: 'label label-primary')
      ded_site?(record.ded_site)
    when 'agent_mission_reward'
      mission_label(record.agent)
    when 'agent_mission_time_bonus_reward'
      mission_label(record.agent, 'Mission Time Bonus')
    end
  end
end
