require "rails_helper"

RSpec.describe "db/seeds.rb" do
  def load_seeds = load(Rails.root.join("db/seeds.rb"))

  it "can run twice without duplicating records" do
    2.times { load_seeds }

    expect([ Bank.count, Account.count, Transaction.count ]).to eq([ 2, 3, 3 ])
  end

  it "includes a repeated hosting invoice that gets flagged" do
    load_seeds

    flagged = Transaction.where.not(duplicate_ids: nil)
    expect(flagged.pluck(:description)).to eq([ "Hosting invoice" ])
  end
end
