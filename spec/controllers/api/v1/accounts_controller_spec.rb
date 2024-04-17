# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::AccountsController, type: :controller do

  describe '#amount' do
    context 'when invalid bank id passed' do
      it 'will returns exception' do
        get :amount, params: { bank_id: Bank.maximum(:id).to_i.next, id: 1 }

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['errors']).to include('Record(s) not found: Account')
      end
    end

    context 'when valid bank id passed' do
      context 'when invalid account id passed' do
        let(:bank) { create(:bank) }

        it 'will returns exception' do
          get :amount, params: { bank_id: bank.id, id: Account.maximum(:id).to_i.next }

          expect(response).to have_http_status(:not_found)
          expect(JSON.parse(response.body)['errors']).to include('Record(s) not found: Account')
        end
      end

      context 'when valid account id passed' do
        let(:account) { create(:account) }

        context 'when no transactions found' do
          it 'will returns response with empty amount' do
            get :amount, params: { bank_id: account.bank.id, id: account.id }

            expect(response).to have_http_status(:ok)
            expect(JSON.parse(response.body)['amount']).to eq('0.0')
          end
        end

        context 'when account has some transactions' do
          let!(:transactions) { create_list(:transaction, 2, account: account, bank: account.bank) }

          it 'will returns sum of transactions amount' do
            get :amount, params: { bank_id: account.bank.id, id: account.id }

            expect(response).to have_http_status(:ok)
            expect(JSON.parse(response.body)['amount'].to_d).to eq(transactions.pluck(:amount).sum.to_f)
          end
        end
      end
    end
  end
end
