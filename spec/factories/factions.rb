# frozen_string_literal: true

FactoryBot.define do
  factory :faction do
    id 500_010
    corporation_id 1_000_127
    name 'Guristas Pirates'
    pattern(/Guristas/i)
  end
end
