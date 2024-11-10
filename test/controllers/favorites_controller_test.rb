require "test_helper"

class FavoriteControllerTest < ActionDispatch::IntegrationTest
  setup do
    login
    @product = products(:megadrive)
    @switch = products(:switch)
  end

  test "should create favorite" do
    assert_difference("Favorite.count", 1) do
      post favorites_url(product_id: @product.id)
    end

    assert_redirected_to product_path(@product)
  end

  test "should delete favorite" do
    assert_difference("Favorite.count", -1) do
      delete favorite_url(@switch.id)
    end

    assert_redirected_to product_path(@switch)
  end
end
