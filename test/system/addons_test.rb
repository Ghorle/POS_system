require "application_system_test_case"

class AddonsTest < ApplicationSystemTestCase
  setup do
    @addon = addons(:one)
  end

  test "visiting the index" do
    visit addons_url
    assert_selector "h1", text: "Addons"
  end

  test "creating a Addon" do
    visit addons_url
    click_on "New Addon"

    fill_in "Description", with: @addon.description
    fill_in "Name", with: @addon.name
    fill_in "Price", with: @addon.price
    click_on "Create Addon"

    assert_text "Addon was successfully created"
    click_on "Back"
  end

  test "updating a Addon" do
    visit addons_url
    click_on "Edit", match: :first

    fill_in "Description", with: @addon.description
    fill_in "Name", with: @addon.name
    fill_in "Price", with: @addon.price
    click_on "Update Addon"

    assert_text "Addon was successfully updated"
    click_on "Back"
  end

  test "destroying a Addon" do
    visit addons_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Addon was successfully destroyed"
  end
end
