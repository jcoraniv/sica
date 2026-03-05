module Dashboard
  class HomeController < ApplicationController
    before_action :authenticate_user!

    def index
      @monthly_consumption = Reading.group_by_month(:read_at).sum(:consumption_m3)
      @monthly_revenue = Invoice.group_by_month(:issued_at).sum(:total_amount)
    end
  end
end
