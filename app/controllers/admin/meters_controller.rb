module Admin
  class MetersController < BaseController
    before_action :require_admin!

    def index
      @q = Meter.includes(:user, :zone).ransack(params[:q])
      @pagy, @meters = pagy(@q.result(distinct: true).order(:serial_number))
      load_form_collections
    end

    def new
      load_form_collections
      @meter = Meter.new
    end

    def create
      @meter = Meter.new(meter_params)
      if @meter.save
        redirect_to admin_meters_path, notice: t("controllers.admin.meters.created")
      else
        load_form_collections
        flash.now[:alert] = @meter.errors.full_messages.join(", ")
        render :new, status: :unprocessable_entity
      end
    end

    def update
      meter = Meter.find(params[:id])
      if meter.update(meter_params)
        redirect_to admin_meters_path, notice: t("controllers.admin.meters.updated")
      else
        redirect_to admin_meters_path, alert: meter.errors.full_messages.join(", ")
      end
    end

    def destroy
      meter = Meter.find(params[:id])
      if meter.readings.exists?
        redirect_to admin_meters_path, alert: t("controllers.admin.meters.cannot_delete_with_readings")
        return
      end

      meter.destroy!
      redirect_to admin_meters_path, notice: t("controllers.admin.meters.deleted")
    rescue ActiveRecord::RecordNotDestroyed => e
      redirect_to admin_meters_path, alert: e.record.errors.full_messages.join(", ")
    end

    private

    def meter_params
      params.require(:meter).permit(:serial_number, :location, :user_id, :zone_id, :latitude, :longitude)
    end

    def load_form_collections
      @users = User.order(:name)
      @zones = Zone.order(:name)
    end
  end
end
