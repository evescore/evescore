# frozen_string_literal: true

FactoryBot.define do
  factory :agent do
    trait :agent1 do
      id 3_017_709
      corporation_id 1_000_021
      division 'Security'
      level 4
      name 'Hetora Miritan'
    end
    trait :agent2 do
      id 3_019_286
      corporation_id 1_000_035
      division 'Security'
      level 4
      name 'Haulieras Pirkibo'
    end
  end
end
