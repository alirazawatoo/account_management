require "rails_helper"

RSpec.describe "Transactions API", type: :request do
  let(:json) { response.parsed_body }
  let(:account) { create(:account) }
  let(:path) { "/api/v1/banks/#{account.bank_id}/accounts/#{account.id}/transactions" }
  let(:payload) { { amount: "125.50", description: "Invoice payment", date: "2024-04-24" } }

  describe "POST" do
    it "creates a transaction tied to the account's bank" do
      post path, params: payload, as: :json

      expect(response).to have_http_status(:created)
      expect(json).to include("amount" => "125.5", "description" => "Invoice payment", "flag_transactions" => nil)
      expect(Transaction.last).to have_attributes(account_id: account.id, bank_id: account.bank_id)
    end

    it "flags a repeat of the same amount and description on the same account" do
      post path, params: payload, as: :json
      first_id = response.parsed_body["id"]

      post path, params: payload, as: :json

      expect(response.parsed_body["flag_transactions"].pluck("id")).to eq([ first_id ])
    end

    it "does not flag a matching transaction on a different account" do
      create(:transaction, amount: "125.50", description: "Invoice payment")

      post path, params: payload, as: :json

      expect(json["flag_transactions"]).to be_nil
    end

    it "does not flag the same amount with a different description" do
      post path, params: payload, as: :json
      post path, params: payload.merge(description: "Refund"), as: :json

      expect(json["flag_transactions"]).to be_nil
    end

    it "does not flag transactions older than the window" do
      travel_to(2.minutes.ago) { post path, params: payload, as: :json }

      post path, params: payload, as: :json

      expect(json["flag_transactions"]).to be_nil
    end

    it "validates the date" do
      post path, params: payload.except(:date), as: :json

      expect(response).to have_http_status(:unprocessable_content)
      expect(json["errors"]).to include("Date can't be blank")
    end

    it "returns 404 when the account belongs to another bank" do
      other_bank = create(:bank)

      post "/api/v1/banks/#{other_bank.id}/accounts/#{account.id}/transactions", params: payload, as: :json

      expect(response).to have_http_status(:not_found)
      expect(json["errors"]).to eq("Record(s) not found: Account")
    end
  end

  describe "GET" do
    it "lists the account's transactions only" do
      own = create(:transaction, account: account)
      create(:transaction)

      get path

      expect(response).to have_http_status(:ok)
      expect(json.pluck("id")).to eq([ own.id ])
    end
  end

  describe "PATCH" do
    let!(:transaction) { create(:transaction, account: account, amount: "10.0", description: "Coffee") }

    it "updates only the given attribute" do
      patch "#{path}/#{transaction.id}", params: { description: "Team coffee" }, as: :json

      expect(response).to have_http_status(:ok)
      expect(transaction.reload).to have_attributes(description: "Team coffee", amount: BigDecimal("10.0"))
    end

    it "rejects an update without any attributes" do
      patch "#{path}/#{transaction.id}", params: {}, as: :json

      expect(response).to have_http_status(:unprocessable_content)
      expect(json["errors"]).to include("param is missing")
    end
  end

  describe "DELETE" do
    it "removes the transaction" do
      transaction = create(:transaction, account: account)

      delete "#{path}/#{transaction.id}"

      expect(response).to have_http_status(:ok)
      expect(Transaction.exists?(transaction.id)).to be(false)
    end

    it "cannot delete a transaction through another account" do
      transaction = create(:transaction)

      delete "#{path}/#{transaction.id}"

      expect(response).to have_http_status(:not_found)
    end
  end
end
