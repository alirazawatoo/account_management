# frozen_string_literal: true

module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |resource|
      render json: { errors: "Record(s) not found: #{resource.model.presence || resource}" }, status: :not_found
    end

    rescue_from ActionController::ParameterMissing do |e|
      render json: { errors: e.message }, status: :unprocessable_entity
    end
  end
end
