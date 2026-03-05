module Admin
  class ReadingsController < BaseController
    before_action :require_reader_or_admin!

    def index
      scope = if current_user.admin?
                Reading.includes(:lecturador, meter: :user)
              else
                Reading.where(lecturador: current_user).includes(:lecturador, meter: :user)
              end
      @q = scope.ransack(params[:q])
      @pagy, @readings = pagy(@q.result(distinct: true).order(read_at: :desc))
    end

    def new
      @meters = available_meters
    end

    def create
      meter = Meter.find(params.require(:meter_id))
      result = Readings::CreateReadingService.call(
        lecturador: current_user,
        meter: meter,
        current_reading: params.require(:current_reading),
        read_at: params[:read_at].presence || Time.current,
        notes: params[:notes]
      )

      if result.success?
        redirect_to admin_readings_path, notice: t("controllers.admin.readings.created")
      else
        @meters = available_meters
        flash.now[:alert] = result.errors.join(", ")
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @reading = Reading.find(params[:id])
    end

    def update
      reading = Reading.find(params[:id])
      attrs = params[:reading] || params
      result = Readings::UpdateReadingService.call(
        reading: reading,
        current_reading: attrs[:current_reading],
        read_at: attrs[:read_at].presence || reading.read_at,
        notes: attrs[:notes]
      )

      if result.success?
        redirect_to admin_readings_path, notice: t("controllers.admin.readings.updated")
      else
        @reading = reading
        flash.now[:alert] = result.errors.join(", ")
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def available_meters
      return Meter.includes(:user).order(:serial_number) if current_user.admin?

      Meter.includes(:user).where(zone_id: current_user.zone_id).order(:serial_number)
    end
  end
end
