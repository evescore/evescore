# frozen_string_literal: true

class TypeAttribute < OpenStruct
  include ActionView::Helpers::NumberHelper

  NAME_TO_PRESENTED = [
    { pattern: /(?i-mx:range)|(?i-mx:signature)|(?i-mx:radius)/, unit: 'm', value_as: :number_with_delimiter, divide_by: 1, process_value: :to_i },
    { pattern: /duration/i, unit: 's', value_as: :number_with_delimiter, divide_by: 1000, process_value: :to_f },
    { pattern: /bonus/i, unit: '%', value_as: :number_with_delimiter, divide_by: 1, process_value: :to_i },
    { pattern: /neutralization amount/i, unit: 'GJ', value_as: :number_with_delimiter, divide_by: 1, process_value: :to_i },
    { pattern: /chance/i, unit: '%', value_as: :number_with_delimiter, divide_by: 0.01, process_value: :to_i },
    { pattern: /(?i-mx:speed)|(?i-mx:velocity)/, unit: 'ms/s', value_as: :number_with_delimiter, divide_by: 1, process_value: :to_i },
    { pattern: /bounty/i, unit: 'ISK', value_as: :number_with_delimiter, divide_by: 1, process_value: :to_i },
    { pattern: /(?i-mx:hitpoints)|(?i-mx:shield capa)/, unit: 'HP', value_as: :number_with_delimiter, divide_by: 1, process_value: :to_i }
  ].freeze

  def presented_hash
    NAME_TO_PRESENTED.each do |hash|
      return hash if display_name.match?(hash[:pattern])
    end
  end

  def presented_value
    val = send(presented_hash[:value_as], (value / presented_hash[:divide_by]).send(presented_hash[:process_value]))
    "#{val} #{presented_hash[:unit]}"
  rescue TypeError
    value.to_s
  end

  def to_helper_attribute
    {
      name: display_name,
      value: presented_value,
      raw_value: value.to_f
    }
  end
end
