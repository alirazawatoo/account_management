# frozen_string_literal: true

module Api
  module V1
    class BaseController < ApplicationController
      include ExceptionHandler
      include BaseHandler

      def index
        render json: collection, each_serializer: serializer
      end

      def create
        if new_resource.save
          render json: new_resource, serializer: serializer, status: :created
        else
          render json: { errors: new_resource.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if resource.update(permitted_params)
          render json: resource, serializer: serializer
        else
          render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        if resource.destroy
          render json: resource, serializer: serializer
        else
          render json: { message: resource.errors.full_messages }, status: :unprocessable_entity
        end
      end

      protected

        def new_resource
          @new_resource ||= model.new(permitted_params)
        end

        def resource
          @resource ||= model.find(params[:id])
        end

        def collection
          @collection ||= model.all
        end

        def serializer
          "#{model}Serializer".constantize
        end
    end
  end
end
