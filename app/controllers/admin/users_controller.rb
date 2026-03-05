module Admin
  class UsersController < BaseController
    before_action :require_admin!

    def index
      @q = User.includes(:zone, :category).ransack(params[:q])
      @pagy, @users = pagy(@q.result(distinct: true).order(:name))
      @zones = Zone.order(:name)
      @categories = Category.order(:name)
    end

    def new
      @new_user = User.new(role: :usuario)
      @zones = Zone.order(:name)
      @categories = Category.order(:name)
    end

    def create
      @new_user = User.new(user_create_params)
      if @new_user.save
        redirect_to admin_users_path, notice: t("controllers.admin.users.created")
      else
        @zones = Zone.order(:name)
        @categories = Category.order(:name)
        flash.now[:alert] = @new_user.errors.full_messages.join(", ")
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @user = User.find(params[:id])
      @zones = Zone.order(:name)
      @categories = Category.order(:name)
    end

    def update
      @user = User.find(params[:id])
      attrs = user_create_params.to_h
      attrs.delete("password") if attrs["password"].blank?
      attrs.delete("password_confirmation") if attrs["password_confirmation"].blank?

      if @user.update(attrs)
        redirect_to admin_users_path, notice: t("controllers.admin.users.updated")
      else
        @zones = Zone.order(:name)
        @categories = Category.order(:name)
        flash.now[:alert] = @user.errors.full_messages.join(", ")
        render :edit, status: :unprocessable_entity
      end
    end

    def update_assignment
      user = User.find(params[:id])

      zone_result = if params[:zone_id].present?
                      Users::AssignZoneService.call(user: user, zone: Zone.find(params[:zone_id]))
                    else
                      ServiceResult.success
                    end

      category_result = if params[:category_id].present?
                          Users::AssignCategoryService.call(user: user, category: Category.find(params[:category_id]))
                        else
                          ServiceResult.success
                        end

      if zone_result.success? && category_result.success?
        redirect_to admin_users_path, notice: t("controllers.admin.users.assignments_updated")
      else
        redirect_to admin_users_path, alert: (zone_result.errors + category_result.errors).join(", ")
      end
    end

    private

    def user_create_params
      params.require(:user).permit(:username, :name, :email, :phone, :address, :role, :zone_id, :category_id, :password, :password_confirmation)
    end
  end
end
