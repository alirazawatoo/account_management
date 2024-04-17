# frozen_string_literal: true

module Api
  module V1
    class AccountsController < BaseController
      actions :index, :create

      def amount
        render json: { amount: resource.transactions.sum(:amount) }
      end

      private

        def bank
          @bank ||= Bank.find(params[:bank_id])
        end

        def collection
          @collection ||= bank.accounts
        end

        def resource
          @resource ||= model.find_by!(id: params[:id], bank_id: params[:bank_id])
        end

        def new_resource
          @new_resource ||= collection.new(permitted_params)
        end

        def permitted_params
          params.require(:name)

          params.permit(:name)
        end
    end
  end
end
