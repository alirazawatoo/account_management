# frozen_string_literal: true

FactoryBot.define do
  factory :transaction do
    amount { Faker::Number.decimal(l_digits: 2) }
    description { Faker::Lorem.paragraph }
    date { DateTime.now }

    account { create(:account) }

    bank { account.bank }
  end
end
