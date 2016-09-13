require 'test_helper'

class ReportsControllerTest < ActionDispatch::IntegrationTest
  test "should get dashboard" do
    get reports_dashboard_url
    assert_response :success
  end

  test "should get index" do
    get reports_index_url
    assert_response :success
  end

end
