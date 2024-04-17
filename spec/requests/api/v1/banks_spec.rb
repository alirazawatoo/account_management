require "rails_helper"

RSpec.describe "Banks API", type: :request do
  let(:json) { response.parsed_body }

  describe "GET /api/v1/banks" do
    it "lists banks with their id and name" do
      bank = create(:bank, name: "Harbor Savings")

      get "/api/v1/banks"

      expect(response).to have_http_status(:ok)
      expect(json).to eq([ { "id" => bank.id, "name" => "Harbor Savings" } ])
    end
  end

  describe "POST /api/v1/banks" do
    it "creates a bank from a JSON body" do
      post "/api/v1/banks", params: { name: "Harbor Savings" }, as: :json

      expect(response).to have_http_status(:created)
      expect(json["name"]).to eq("Harbor Savings")
      expect(Bank.count).to eq(1)
    end

    it "rejects a duplicate name" do
      create(:bank, name: "Harbor Savings")

      post "/api/v1/banks", params: { name: "Harbor Savings" }, as: :json

      expect(response).to have_http_status(:unprocessable_content)
      expect(json["errors"]).to include("Name has already been taken")
    end
  end

  describe "PATCH /api/v1/banks/:id" do
    it "renames the bank" do
      bank = create(:bank)

      patch "/api/v1/banks/#{bank.id}", params: { name: "Renamed" }, as: :json

      expect(response).to have_http_status(:ok)
      expect(bank.reload.name).to eq("Renamed")
    end
  end

  describe "DELETE /api/v1/banks/:id" do
    it "deletes a bank without accounts" do
      bank = create(:bank)

      delete "/api/v1/banks/#{bank.id}"

      expect(response).to have_http_status(:ok)
      expect(Bank.exists?(bank.id)).to be(false)
    end

    it "refuses to delete a bank that still has accounts" do
      account = create(:account)

      delete "/api/v1/banks/#{account.bank_id}"

      expect(response).to have_http_status(:unprocessable_content)
      expect(json["errors"]).to include("Cannot delete record because dependent accounts exist")
      expect(Bank.exists?(account.bank_id)).to be(true)
    end

    it "returns 404 for an unknown bank" do
      delete "/api/v1/banks/0"

      expect(response).to have_http_status(:not_found)
      expect(json["errors"]).to eq("Record(s) not found: Bank")
    end
  end
end
