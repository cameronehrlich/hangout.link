require 'test_helper'

class ApiControllerTest < ActionController::TestCase
  test "should get check_subdomain" do
    get :check_subdomain
    assert_response :success
  end

end
