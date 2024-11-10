class ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit update destroy]
  skip_before_action :protect_pages, only: %i[index show]

  def index
    @categories = Category.all.order(name: :asc).load_async

    page = params[:page].present? ? params[:page].to_i : 1
    @pagy, @products = pagy_countless(FindProducts.new.call(products_params_query).load_async, page: page, limit: 12)
  end

  def show
  end

  def new
    @product = Product.new
  end

  def create
    # First method to create a product with a user, othes is at the model
    # @product = current_user.products.new(product_params)
    @product = Product.new(product_params)

    if @product.save
      redirect_to products_path, notice: t(".created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize! @product
  end

  def update
    authorize! @product

    if @product.update(product_params)
      redirect_to products_path, notice: t(".updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! @product

    if @product.destroy
      redirect_to products_path, notice: t(".destroyed"), status: :see_other
    else
      render :destroy, status: :unprocessable_entity
    end
  end

  private

  def product_params
    params.require(:product).permit(:title, :description, :price, :photo, :category_id)
  end

  def products_params_query
    params.permit(:category_id, :min_price, :max_price, :query_text, :order_by, :page)
  end

  def set_product
    @product = Product.find(params[:id])
  end
end
