require 'test_helper'

class BeersControllerTest < ActionController::TestCase
  setup do
    @beer = beers(:beers_001)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:beers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create beer" do
    assert_difference('Beer.count') do
      post :create, beer: { name: 'Pale Ale', brewer_id: 1, format_id: 1, price: 320.0, style_id: 2, abv: 5.6, note: 'Classic NZ version of a crisp, hoppy, refreshing American Pale Ale. Plenty of citrus notes for the hopheads but not too threatening for the beerginner.', location_id: 7 }
    end

    assert_redirected_to :controller => 'beers'
  end

  test "should show beer" do
    get :show, id: @beer
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @beer
    assert_response :success
  end

  test "should update beer" do
    patch :update, id: @beer, beer: { abv: 5.7 }
    assert_redirected_to :controller => 'beers'
  end

  test "should destroy beer" do
    assert_difference('Beer.count', -1) do
      delete :destroy, id: @beer
    end

    assert_redirected_to beers_path
  end
end
