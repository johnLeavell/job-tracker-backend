require 'test_helper'

class Api::V1::JobsTagsControllerTest < ActionDispatch::IntegrationTest
  test "index returns jobs_tags for the current user's jobs only" do
    get api_v1_jobs_tags_url, headers: auth_headers(users(:alice))
    assert_response :success
    assert_equal 2, JSON.parse(response.body).size
  end

  test "create links a tag to a job the user owns" do
    job = jobs(:alice_job_interviewing)

    assert_difference("JobsTag.count", 1) do
      post api_v1_jobs_tags_url, params: { job_id: job.id, tag_id: tags(:remote).id }, headers: auth_headers(users(:alice))
    end
    assert_response :created
  end

  test "create fails for a job owned by another user" do
    post api_v1_jobs_tags_url,
      params: { job_id: jobs(:alice_job_applied).id, tag_id: tags(:remote).id },
      headers: auth_headers(users(:bob))

    assert_response :not_found
  end

  test "destroy unlinks a tag from a job" do
    jobs_tag = jobs_tags(:one)

    assert_difference("JobsTag.count", -1) do
      delete api_v1_jobs_tag_url(jobs_tag), headers: auth_headers(users(:alice))
    end
    assert_response :no_content
  end
end
