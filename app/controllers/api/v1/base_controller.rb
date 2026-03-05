module Api
  module V1
    class BaseController < ApplicationController
      before_action :authenticate_user!

      private

      def render_result(result, success_status: :ok)
        if result.success?
          render json: { success: true, payload: result.payload }, status: success_status
        else
          render json: { success: false, errors: result.errors }, status: :unprocessable_entity
        end
      end
    end
  end
end
