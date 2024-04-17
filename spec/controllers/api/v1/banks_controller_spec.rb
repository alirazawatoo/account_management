# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::BanksController, type: :controller do

  describe '#index' do
    context 'when request all banks' do
      context 'when there are no banks exists' do
        it 'will returns empty response' do
          get :index
  
          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)).to be_empty
        end
      end

      context 'when banks exists' do
        let!(:bank) { create(:bank) }
        let!(:bank_1) { create(:bank) }

        it 'will returns all banks' do
          get :index

          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body).pluck('name')).to include(bank.name)
        end
      end
    end
  end

  describe '#create' do
    context 'when correct params provided' do
      let(:params) do
        {
          name: Faker::Bank.name
        }
      end

      it 'will create new bank' do
        post :create, params: params

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['name']).to eq(params[:name])
      end
    end

    context 'when requested to create bank with existing name' do
      let(:bank) { create(:bank) }
      let(:params) do
        {
          name: bank.name
        }
      end

      it 'will returns exception' do
        post :create, params: params

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).to include('Name has already been taken')
      end
    end

    context 'when required params are missing' do
      it 'will returns exception' do
        post :create

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).to include('param is missing or the value is empty: name')
      end
    end
  end

  describe '#update' do
    context 'when record does not found' do
      it 'will returns exception' do
        patch :update, params: { id: Bank.maximum(:id).to_i.next }

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['errors']).to eq('Record(s) not found: Bank')
      end
    end
    
    context 'when record found' do
      let(:bank) { create(:bank) }

      context 'when updated params are missing' do
        it 'will returns exception' do
          patch :update, params: { id: bank.id }

          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)['errors']).to include('param is missing or the value is empty: name')
        end
      end

      context 'when updated params are present' do
        let(:params) do
          {
            id: bank.id,
            name: bank.name + 'test'
          }
        end

        it 'will return updated record' do
          expect(bank.name).not_to eq(params[:name])

          patch :update, params: params

          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)['name']).to eq(params[:name])
        end
      end

      context 'when bank already exists with same name' do
        let(:bank_1) { create(:bank) }
        let(:params) do
          {
            id: bank.id,
            name: bank_1.name
          }
        end

        it 'will returns exception' do
          patch :update, params: params

          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)['errors']).to include('Name has already been taken')
        end
      end
    end
  end

  describe '#destroy' do
    context 'when record does not found' do
      it 'will returns exception' do
        delete :destroy, params: { id: Bank.maximum(:id).to_i.next }

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['errors']).to eq('Record(s) not found: Bank')
      end
    end
    
    context 'when record found' do
      let(:bank) { create(:bank) }

      it 'will returns deleted record' do
        delete :destroy, params: { id: bank.id }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['name']).to eq(bank.name)
      end

      context 'when record unable to destroy' do
        let(:bank_1) { build_stubbed(:bank) }

        before do
          allow(bank_1).to receive(:destroy).and_return(false)
          allow(Bank).to receive(:find).and_return(bank_1)
        end
        it 'returns exceptions' do
          delete :destroy, params: { id: bank_1.id }

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end
end
