module Admin
  class ZonesController < BaseController
    before_action :require_admin!

    def index
      @q = Zone.ransack(params[:q])
      @pagy, @zones = pagy(@q.result(distinct: true).order(:name))
      @zone = params[:edit_id].present? ? Zone.find(params[:edit_id]) : Zone.new
    end

    def create
      @zone = Zone.new(zone_params)
      if @zone.save
        redirect_to admin_zones_path, notice: t("controllers.admin.zones.created")
      else
        @q = Zone.ransack(params[:q])
        @pagy, @zones = pagy(@q.result(distinct: true).order(:name))
        flash.now[:alert] = @zone.errors.full_messages.join(", ")
        render :index, status: :unprocessable_entity
      end
    end

    def update
      @zone = Zone.find(params[:id])
      if @zone.update(zone_params)
        redirect_to admin_zones_path, notice: t("controllers.admin.zones.updated")
      else
        @q = Zone.ransack(params[:q])
        @pagy, @zones = pagy(@q.result(distinct: true).order(:name))
        flash.now[:alert] = @zone.errors.full_messages.join(", ")
        render :index, status: :unprocessable_entity
      end
    end

    private

    def zone_params
      params.require(:zone).permit(:name, :description)
    end
  end
end
