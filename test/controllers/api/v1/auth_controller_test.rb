require 'test_helper'

class Api::V1::AuthControllerTest < ActionDispatch::IntegrationTest
  test "login succeeds with correct credentials" do
    post api_v1_login_url, params: { username: "alice", password: "password" }
    assert_response :success
    assert JSON.parse(response.body)["token"].present?
  end

  test "login fails with incorrect password" do
    post api_v1_login_url, params: { username: "alice", password: "wrong" }
    assert_response :unauthorized
  end

  test "auto_login returns the current user for a valid token" do
    get api_v1_auto_login_url, headers: auth_headers(users(:alice))
    assert_response :success
    assert_equal "alice", JSON.parse(response.body)["username"]
  end

  test "auto_login fails without a token" do
    get api_v1_auto_login_url
    assert_response :unauthorized
  end
end
