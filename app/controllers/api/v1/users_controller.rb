module Api
  module V1
    class UsersController < BaseController
      def assign_zone
        user = User.find(params[:id])
        zone = Zone.find(params.require(:zone_id))
        authorize user, :manage_assignments?

        result = Users::AssignZoneService.call(user: user, zone: zone)
        render_result(result)
      end

      def assign_category
        user = User.find(params[:id])
        category = Category.find(params.require(:category_id))
        authorize user, :manage_assignments?

        result = Users::AssignCategoryService.call(user: user, category: category)
        render_result(result)
      end
    end
  end
end
