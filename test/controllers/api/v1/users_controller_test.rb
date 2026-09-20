require 'test_helper'

class Api::V1::UsersControllerTest < ActionDispatch::IntegrationTest
  test "create signs up a new user and returns a token" do
    assert_difference("User.count", 1) do
      post api_v1_signup_url, params: { username: "newperson", password: "password" }
    end

    assert_response :created
    body = JSON.parse(response.body)
    assert_equal "newperson", body["user"]["username"]
    assert body["token"].present?
  end

  test "create rejects a duplicate username" do
    assert_no_difference("User.count") do
      post api_v1_signup_url, params: { username: "alice", password: "password" }
    end
    assert_response :unprocessable_entity
  end

  test "profile requires authorization" do
    get api_v1_profile_url
    assert_response :unauthorized
  end

  test "profile returns the current user" do
    get api_v1_profile_url, headers: auth_headers(users(:alice))
    assert_response :success
    assert_equal "alice", JSON.parse(response.body)["username"]
  end
end
