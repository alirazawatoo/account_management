# frozen_string_literal: true

module Api
  module V1
    class BanksController < BaseController
      actions :index, :create, :update, :destroy

      private

        def permitted_params
          params.require(:name)

          params.permit(:name)
        end
    end
  end
end
