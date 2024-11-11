require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  def setup
    login
  end
  test "render a list of producst" do
    get products_path

    assert_response :success
    assert_select ".product", 12
    assert_select ".category", 10
  end

  test "render a list of products filtered by category" do
    get products_path(category_id: categories(:computers).id)

    assert_response :success
    assert_select ".product", 5
  end

  test "render a list of products filtered by min_price and max_price" do
    get products_path(min_price: 180, max_price: 200)

    assert_response :success
    assert_select ".product", 2
    assert_select "h2", "Nintendo Switch"
  end

  test "render a list of products searched by query_text" do
    get products_path(query_text: "macbook")

    assert_response :success
    assert_select ".product", 1
    assert_select "h2", "Macbook Air"
  end

  test "sort products by expensive prices first" do
    get products_path(order_by: "expensive")

    assert_response :success
    assert_select ".product", 12
    assert_select ".products .product:first-child h2", "Seat Panda clásico"
  end

  test "render a detailed product page" do
    get product_path(products(:ps4))

    assert_response :success
    assert_select ".title", "PS4 Fat"
    assert_select ".description", "PS4 en buen estado"
    assert_select ".price", "$ 150"
  end

  test "render a new product form" do
    get new_product_path

    assert_response :success
    assert_select "form"
  end

  test "allow to create a new product" do
    post products_path, params: {
      product: {
        title: "Nintendo 64",
        description: "Le faltan los cables",
        price: 30,
        category_id: categories(:videogames).id
      }
    }

    assert_redirected_to products_path
    assert_equal flash[:notice], "Tu producto se a creado correctamente"
  end

  test "does nor allow to craete a new product with empty fields" do
    post products_path, params: {
      product: {
        title: "",
        description: "Le faltan los cables",
        price: 30
      }
    }

    assert_response :unprocessable_entity
  end

  test "render an edit product path" do
    get edit_product_path(products(:ps4))

    assert_response :success
    assert_select "form"
  end

  test "allows to update a product" do
    patch product_path(products(:ps4)), params: {
      product: {
        title: "PS4 renovada"
      }
    }

    assert_redirected_to products_path
    assert_equal flash[:notice], "Tu producto se ha actualizado"
  end

  test "does not allow to update a product with an invalid field" do
    patch product_path(products(:ps4)), params: {
      product: {
        title: nil
      }
    }

    assert_response :unprocessable_entity
  end

  test "can delete products" do
    assert_difference("Product.count", -1) do
      delete product_path(products(:ps4))
    end

    assert_redirected_to products_path
    assert_equal flash[:notice], "Tu producto se ha eliminado"
  end
end
