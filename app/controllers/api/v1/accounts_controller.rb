# frozen_string_literal: true

module Api
  module V1
    class AccountsController < BaseController
      
      def amount
        render json: { amount: resource.transactions.sum(:amount) }
      end

      private

        def resource
          @resource ||= model.find_by!(id: params[:id], bank_id: params[:bank_id])
        end
    end
  end
end
