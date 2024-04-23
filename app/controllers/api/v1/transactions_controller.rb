# frozen_string_literal: true

module Api
  module V1
    class TransactionsController < BaseController
      actions :index, :create, :update, :destroy

      private

        def collection
          @collection ||= account.transactions
        end

        def resource
          @resource ||= collection.find(params[:id])
        end

        def new_resource
          @new_resource ||= collection.new(permitted_params.merge(bank_id: params[:bank_id]))
        end

        def account
          @account ||= Account.find_by!(bank_id: params[:bank_id], id: params[:account_id])
        end

        def permitted_params
          params.require(:amount)

          params.permit(:amount, :description, :date)
        end
    end
  end
end
