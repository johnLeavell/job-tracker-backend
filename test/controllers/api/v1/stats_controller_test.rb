require 'test_helper'

class Api::V1::StatsControllerTest < ActionDispatch::IntegrationTest
  test "requires authorization" do
    get api_v1_stats_url
    assert_response :unauthorized
  end

  test "returns funnel counts and rates for the current user" do
    get api_v1_stats_url, headers: auth_headers(users(:alice))
    assert_response :success

    body = JSON.parse(response.body)
    assert_equal 2, body["total_applications"]
    assert_equal 1, body["by_status"]["applied"]
    assert_equal 1, body["by_status"]["interviewing"]
    assert body["rates"]["response_rate"].present?
    assert body["by_resume"].key?(resumes(:alice_resume).name)
  end

  test "scopes stats to the current user only" do
    get api_v1_stats_url, headers: auth_headers(users(:bob))
    assert_response :success

    body = JSON.parse(response.body)
    assert_equal 0, body["total_applications"]
  end
end
