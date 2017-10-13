# frozen_string_literal: true

module Rats
  class Attributes < GenericAttributes
    HELPER_PRESENTERS = [
      { name: :web, title: 'Stasis Webifier', attributes: %i[modify_target_speed_range modify_target_speed_duration speed_factor modify_target_speed_chance] },
      { name: :neut, title: 'Energy Neutrilizer', attributes: %i[energy_neutralizer_range_optimal energy_neutralizer_duration energy_neutralizer_amount energy_neutralizer_entity_chance] },
      { name: :scram, title: 'Warp Scramble', attributes: %i[warp_scramble_range warp_scramble_strength entity_warp_scramble_chance] },
      { name: :ecm, title: 'ECM', attributes: %i[ecm_range_optimal ecm_duration ecm_entity_chance] }
    ].freeze

    HELPER_PRESENTERS.each do |row|
      define_method(row[:name]) do
        attributes = row[:attributes].map { |a| send(a).to_helper_attribute }
        raise StandardError if attributes.map { |a| a[:raw_value] }.uniq.first == 0.0
        { icon: row[:name].to_s, title: row[:title], attributes: attributes }
      end
    end

    def repair_value(type)
      send("entity_#{type}_amount").value / (send("entity_#{type}_duration").value / 1000)
    rescue StandardError
      begin
        send("entity_#{type}_amount_per_second").value
      rescue StandardError
        send(:shield_capacity).value / (send(:shield_recharge_rate).value / 1000)
      end
    end
  end
end
