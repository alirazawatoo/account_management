# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::TransactionsController, type: :controller do

  describe '#index' do
    let(:account) { create(:account) }
    let!(:default_transaction) { create(:transaction) }
    let(:params) do
      {
        bank_id: account.bank.id,
        account_id: account.id
      }
    end

    context 'when account does not found with wrong bank id' do
      let(:updated_params) { params.merge(bank_id: Bank.maximum(:id).to_i.next) }

      it 'will returns not found exception' do
        get :index, params: updated_params

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['errors']).to eq('Record(s) not found: Account')
      end
    end

    context 'when account found with valid bank id' do
      context 'when account_id is invalid' do
        let(:updated_params) { params.merge(account_id: Account.maximum(:id).to_i.next) }

        it 'will returns exception' do
          get :index, params: updated_params

          expect(response).to have_http_status(:not_found)
          expect(JSON.parse(response.body)['errors']).to eq('Record(s) not found: Account')
        end
      end

      context 'when account found with valid bank id and account id' do
        context 'when there are no transactions exists' do
          it 'will returns empty response' do
            get :index, params: params
    
            expect(response).to have_http_status(:ok)
            expect(JSON.parse(response.body)).to be_empty
          end
        end

        context 'when transactions exists' do
          let!(:transactions) do
            create_list(:transaction, 2, 
                        account: account, 
                        amount: Faker::Number.decimal(l_digits: 2), 
                        description: Faker::Lorem.paragraph)
          end

          it 'will returns all transactions' do
            get :index, params: params

            expect(response).to have_http_status(:ok)
            expect(JSON.parse(response.body).pluck('amount').map(&:to_d)).to include(transactions.first.amount.to_d)
          end

          it 'will returns all transactions along with duplicated transactions' do
            get :index, params: params

            expect(response).to have_http_status(:ok)
            expect(JSON.parse(response.body).last['flag_transactions'].pluck('id')).to include(transactions.first.id)
          end
        end
      end
    end
  end

  describe '#create' do
    let(:account) { create(:account) }
    let(:params) do
      {
        bank_id: account.bank.id,
        account_id: account.id
      }
    end

    context 'when account does not found with wrong bank_id' do
      let(:updated_params) { params.merge(bank_id: Bank.maximum(:id).to_i.next) }

      it 'will returns not found exception' do
        post :create, params: updated_params

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['errors']).to eq('Record(s) not found: Account')
      end
    end

    context 'when bank id is valid' do
      context 'when account_id is invalid' do
        let(:updated_params) { params.merge(account_id: Account.maximum(:id).to_i.next) }

        it 'will returns exception' do
          post :create, params: updated_params

          expect(response).to have_http_status(:not_found)
          expect(JSON.parse(response.body)['errors']).to eq('Record(s) not found: Account')
        end
      end

      context 'when account_id is valid' do
        context 'when required params are missing' do
          it 'will returns exception' do
            post :create, params: params

            expect(response).to have_http_status(:unprocessable_entity)
            expect(JSON.parse(response.body)['errors']).to include('param is missing or the value is empty:')
          end
        end

        context 'when required params are present' do
          let(:updated_params) { params.merge(amount: '10.0', description: Faker::Lorem.paragraph, date: DateTime.now) }

          it 'will create transaction' do
            post :create, params: updated_params

            expect(response).to have_http_status(:created)
            expect(JSON.parse(response.body)['description']).to eq(updated_params[:description])
          end
        end
      end
    end
  end

  describe '#update' do
    let(:account) { create(:account) }
    let(:params) do
      {
        bank_id: account.bank.id,
        account_id: account.id
      }
    end

    context 'when bank does not found' do
      let(:updated_params) { params.merge(bank_id: Bank.maximum(:id).to_i.next) }

      it 'will returns not found exception' do
        post :create, params: updated_params

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['errors']).to eq('Record(s) not found: Account')
      end
    end

    context 'when bank found' do
      context 'when account_id is invalid' do
        let(:updated_params) { params.merge(account_id: Account.maximum(:id).to_i.next) }

        it 'will returns exception' do
          post :create, params: updated_params

          expect(response).to have_http_status(:not_found)
          expect(JSON.parse(response.body)['errors']).to eq('Record(s) not found: Account')
        end
      end

      context 'when account_id is valid' do
        context 'when record does not found' do
          let(:updated_params) { params.merge(id: Transaction.maximum(:id).to_i.next) }

          it 'will returns exception' do
            patch :update, params: updated_params

            expect(response).to have_http_status(:not_found)
            expect(JSON.parse(response.body)['errors']).to eq('Record(s) not found: Transaction')
          end
        end
        
        context 'when record found' do
          let(:transaction) { create(:transaction, account: account) }
          let(:updated_params) { params.merge(id: transaction.id) }

          context 'when updated params are missing' do
            it 'will returns exception' do
              patch :update, params: updated_params

              expect(response).to have_http_status(:unprocessable_entity)
              expect(JSON.parse(response.body)['errors']).to include('param is missing or the value is empty:')
            end
          end

          context 'when updated params are present' do
            let(:transaction) { create(:transaction, account: account) }
            let(:updated_params) { params.merge(id: transaction.id, amount: '10.0') }

            it 'will return updated record' do
              expect(transaction.amount).not_to eq(updated_params[:name])

              patch :update, params: updated_params

              expect(response).to have_http_status(:ok)
              expect(JSON.parse(response.body)['amount']).to eq(updated_params[:amount])
            end
          end
        end
      end
    end
  end

  describe '#destroy' do
    let(:account) { create(:account) }
    let(:params) do
      {
        bank_id: account.bank.id,
        account_id: account.id
      }
    end

    let(:transaction) { create(:transaction, account: account) }

    context 'when record does not found' do
      let(:updated_params) { params.merge(id: Transaction.maximum(:id).to_i.next) }

      it 'will returns exception' do
        delete :destroy, params: updated_params

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['errors']).to eq('Record(s) not found: Transaction')
      end
    end
    
    context 'when record found' do
      let(:updated_params) { params.merge(id: transaction.id) }

      it 'will returns deleted record' do
        delete :destroy, params: updated_params

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['description']).to eq(transaction.description)
      end
    end
  end
end
