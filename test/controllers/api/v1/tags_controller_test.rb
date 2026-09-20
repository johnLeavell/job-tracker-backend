require 'test_helper'

class Api::V1::TagsControllerTest < ActionDispatch::IntegrationTest
  test "index requires authorization" do
    get api_v1_tags_url
    assert_response :unauthorized
  end

  test "index lists all tags" do
    get api_v1_tags_url, headers: auth_headers(users(:alice))
    assert_response :success
    assert_equal Tag.count, JSON.parse(response.body).size
  end

  test "create adds a new tag" do
    assert_difference("Tag.count", 1) do
      post api_v1_tags_url, params: { name: "onsite" }, headers: auth_headers(users(:alice))
    end
    assert_response :created
  end

  test "create rejects a duplicate name" do
    assert_no_difference("Tag.count") do
      post api_v1_tags_url, params: { name: "remote" }, headers: auth_headers(users(:alice))
    end
    assert_response :unprocessable_entity
  end

  test "destroy removes a tag" do
    assert_difference("Tag.count", -1) do
      delete api_v1_tag_url(tags(:backend)), headers: auth_headers(users(:alice))
    end
    assert_response :no_content
  end
end
