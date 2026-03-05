module Admin
  class ReaderZonesController < BaseController
    before_action :require_reader_or_admin!

    def index
      scope = current_user.admin? ? Zone.all : Zone.where(id: current_user.zone_id)
      @zones = scope.left_joins(:meters)
                    .select("zones.*, COUNT(meters.id) AS meters_count")
                    .group("zones.id")
                    .order(:name)
    end

    def show
      @zone = find_allowed_zone(params[:id])
      @meters = @zone.meters.select(:id, :serial_number, :location, :latitude, :longitude)
      @markers = @meters.where.not(latitude: nil, longitude: nil).map do |meter|
        {
          id: meter.id,
          serial_number: meter.serial_number,
          location: meter.location,
          latitude: meter.latitude.to_f,
          longitude: meter.longitude.to_f
        }
      end
    end

    private

    def find_allowed_zone(zone_id)
      zone = Zone.find(zone_id)
      return zone if current_user.admin?
      return zone if current_user.zone_id == zone.id

      raise ActiveRecord::RecordNotFound
    end
  end
end
