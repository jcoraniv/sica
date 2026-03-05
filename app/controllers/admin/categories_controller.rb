module Admin
  class CategoriesController < BaseController
    before_action :require_admin!

    def index
      @q = Category.ransack(params[:q])
      @pagy, @categories = pagy(@q.result(distinct: true).order(:name))
      @category = params[:edit_id].present? ? Category.find(params[:edit_id]) : Category.new
    end

    def create
      @category = Category.new(category_params)
      if @category.save
        redirect_to admin_categories_path, notice: t("controllers.admin.categories.created")
      else
        @q = Category.ransack(params[:q])
        @pagy, @categories = pagy(@q.result(distinct: true).order(:name))
        flash.now[:alert] = @category.errors.full_messages.join(", ")
        render :index, status: :unprocessable_entity
      end
    end

    def update
      @category = Category.find(params[:id])
      if @category.update(category_params)
        redirect_to admin_categories_path, notice: t("controllers.admin.categories.updated")
      else
        @q = Category.ransack(params[:q])
        @pagy, @categories = pagy(@q.result(distinct: true).order(:name))
        flash.now[:alert] = @category.errors.full_messages.join(", ")
        render :index, status: :unprocessable_entity
      end
    end

    private

    def category_params
      params.require(:category).permit(:name, :price_per_m3, :surcharge_percentage)
    end
  end
end
