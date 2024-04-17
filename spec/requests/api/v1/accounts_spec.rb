require "rails_helper"

RSpec.describe "Accounts API", type: :request do
  let(:json) { response.parsed_body }
  let(:bank) { create(:bank) }

  describe "GET /api/v1/banks/:bank_id/accounts" do
    it "lists only the accounts of that bank" do
      own = create(:account, bank: bank, name: "Operating")
      create(:account, name: "Elsewhere")

      get "/api/v1/banks/#{bank.id}/accounts"

      expect(response).to have_http_status(:ok)
      expect(json).to eq([ { "id" => own.id, "name" => "Operating", "bank_id" => bank.id } ])
    end

    it "returns 404 for an unknown bank" do
      get "/api/v1/banks/0/accounts"

      expect(response).to have_http_status(:not_found)
      expect(json["errors"]).to eq("Record(s) not found: Bank")
    end
  end

  describe "POST /api/v1/banks/:bank_id/accounts" do
    it "opens an account in the bank" do
      post "/api/v1/banks/#{bank.id}/accounts", params: { name: "Payroll" }, as: :json

      expect(response).to have_http_status(:created)
      expect(json).to include("name" => "Payroll", "bank_id" => bank.id)
    end

    it "requires a name" do
      post "/api/v1/banks/#{bank.id}/accounts", params: {}, as: :json

      expect(response).to have_http_status(:unprocessable_content)
      expect(json["errors"]).to include("param is missing")
    end
  end

  describe "GET /api/v1/banks/:bank_id/accounts/:id/amount" do
    it "sums the account's transaction amounts" do
      account = create(:account, bank: bank)
      create(:transaction, account: account, amount: "100.25", description: "Deposit")
      create(:transaction, account: account, amount: "-40.00", description: "Card payment")
      create(:transaction, amount: "999")

      get "/api/v1/banks/#{bank.id}/accounts/#{account.id}/amount"

      expect(response).to have_http_status(:ok)
      expect(json["amount"].to_d).to eq(BigDecimal("60.25"))
    end

    it "does not resolve an account through another bank" do
      account = create(:account)

      get "/api/v1/banks/#{bank.id}/accounts/#{account.id}/amount"

      expect(response).to have_http_status(:not_found)
    end
  end
end
