# frozen_string_literal: true

module Api
  module V1
    class TransactionsController < BaseController
      ATTRIBUTES = %i[amount description date].freeze

      actions :index, :create, :update, :destroy

      private

        def collection
          @collection ||= account.transactions
        end

        def resource
          @resource ||= collection.find(params[:id])
        end

        def new_resource
          @new_resource ||= collection.new(permitted_params.merge(bank_id: account.bank_id))
        end

        def account
          @account ||= Account.find_by!(bank_id: params[:bank_id], id: params[:account_id])
        end

        # Creation needs an amount; a PATCH may change any subset of the attributes.
        def permitted_params
          if action_name == "create"
            params.require(:amount)
          elsif params.slice(*ATTRIBUTES).blank?
            raise ActionController::ParameterMissing.new(ATTRIBUTES.join(", "))
          end

          params.permit(*ATTRIBUTES)
        end
    end
  end
end
