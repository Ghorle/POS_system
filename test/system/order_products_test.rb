require "application_system_test_case"

class OrderProductsTest < ApplicationSystemTestCase
  setup do
    @order_product = order_products(:one)
  end

  test "visiting the index" do
    visit order_products_url
    assert_selector "h1", text: "Order Products"
  end

  test "creating a Order product" do
    visit order_products_url
    click_on "New Order Product"

    fill_in "Name", with: @order_product.name
    click_on "Create Order product"

    assert_text "Order product was successfully created"
    click_on "Back"
  end

  test "updating a Order product" do
    visit order_products_url
    click_on "Edit", match: :first

    fill_in "Name", with: @order_product.name
    click_on "Update Order product"

    assert_text "Order product was successfully updated"
    click_on "Back"
  end

  test "destroying a Order product" do
    visit order_products_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Order product was successfully destroyed"
  end
end
