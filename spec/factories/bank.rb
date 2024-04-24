# frozen_string_literal: true

FactoryBot.define do
  factory :bank do
    sequence(:name) { |n| Faker::Bank.name + n.to_s }
  end
end
