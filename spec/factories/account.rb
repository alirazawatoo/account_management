# frozen_string_literal: true

FactoryBot.define do
  factory :account do
    sequence(:name) { |n| Faker::Bank.name + n.to_s }

    association :bank
  end
end
