module Api
  module V1
    class ReadingsController < BaseController
      def create
        meter = Meter.find(params.require(:meter_id))
        authorize Reading, :create?

        result = Readings::CreateReadingService.call(
          lecturador: current_user,
          meter: meter,
          current_reading: params.require(:current_reading),
          read_at: params[:read_at] || Time.current,
          notes: params[:notes]
        )

        render_result(result, success_status: :created)
      end

      def update
        reading = Reading.find(params[:id])
        authorize reading, :update?

        result = Readings::UpdateReadingService.call(
          reading: reading,
          current_reading: params.require(:current_reading),
          read_at: params[:read_at] || Time.current,
          notes: params[:notes]
        )

        render_result(result)
      end
    end
  end
end
