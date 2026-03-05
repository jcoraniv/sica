module Admin
  class ProfilesController < BaseController
    def show
      @user = current_user
      @meters = @user.meters.order(:serial_number)
    end

    def edit
      @user = current_user
      @zones = Zone.order(:name)
      @categories = Category.order(:name)
    end

    def update
      @user = current_user
      attrs = profile_params.to_h
      attrs.delete("password") if attrs["password"].blank?
      attrs.delete("password_confirmation") if attrs["password_confirmation"].blank?

      if @user.update(attrs)
        redirect_to admin_profile_path, notice: t("controllers.admin.profiles.updated")
      else
        @zones = Zone.order(:name)
        @categories = Category.order(:name)
        flash.now[:alert] = @user.errors.full_messages.join(", ")
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def profile_params
      params.require(:user).permit(:username, :name, :email, :phone, :address, :password, :password_confirmation)
    end
  end
end
