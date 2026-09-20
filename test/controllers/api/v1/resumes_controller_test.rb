require 'test_helper'

class Api::V1::ResumesControllerTest < ActionDispatch::IntegrationTest
  test "index returns only the current user's resumes" do
    get api_v1_resumes_url, headers: auth_headers(users(:alice))
    assert_response :success

    names = JSON.parse(response.body).map { |r| r["name"] }
    assert_includes names, resumes(:alice_resume).name
  end

  test "create adds a resume for the current user" do
    assert_difference("users(:bob).resumes.count", 1) do
      post api_v1_resumes_url, params: { name: "Full Stack v1" }, headers: auth_headers(users(:bob))
    end
    assert_response :created
  end

  test "show returns 404 for another user's resume" do
    get api_v1_resume_url(resumes(:alice_resume)), headers: auth_headers(users(:bob))
    assert_response :not_found
  end

  test "destroy removes the resume" do
    assert_difference("Resume.count", -1) do
      delete api_v1_resume_url(resumes(:alice_resume)), headers: auth_headers(users(:alice))
    end
    assert_response :no_content
  end
end
