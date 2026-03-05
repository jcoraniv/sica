module Admin
  class DashboardController < BaseController
    def index
      @stats = {
        users: User.count,
        meters: Meter.count,
        pending_invoices: Invoice.pending.count,
        total_due: Invoice.pending.sum(:total_amount)
      }

      @readings_chart = if current_user.admin?
                          Reading.group_by_month(:read_at).sum(:consumption_m3)
                        elsif current_user.lecturador?
                          Reading.where(lecturador: current_user).group_by_month(:read_at).sum(:consumption_m3)
                        else
                          Reading.joins(:meter).where(meters: { user_id: current_user.id }).group_by_month(:read_at).sum(:consumption_m3)
                        end

      @invoices = if current_user.admin?
                    Invoice.includes(:user).order(issued_at: :desc).limit(8)
                  elsif current_user.lecturador?
                    Invoice.joins(:reading).where(readings: { lecturador_id: current_user.id }).includes(:user).order(issued_at: :desc).limit(8)
                  else
                    Invoice.where(user: current_user).order(issued_at: :desc).limit(8)
                  end
    end
  end
end
