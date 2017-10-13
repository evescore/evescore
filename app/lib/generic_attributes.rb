# frozen_string_literal: true

class GenericAttributes
  attr_reader :array
  def initialize(array)
    @array = array
  end

  def summarize_damage
    total = 0
    %i[kinetic thermal explosive em].each do |type|
      begin
        type_damage = send("#{type}_damage").value
      rescue StandardError
        type_damage = 0
      end
      total += type_damage
    end
    total
  end

  def method_missing(method_name)
    @array.select do |attribute|
      attribute.name.underscore == method_name.to_s
    end.first || super
  end

  def respond_to_missing?(*args)
    super
  end
end
