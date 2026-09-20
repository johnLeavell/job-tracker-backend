require 'test_helper'

class Api::V1::JobsControllerTest < ActionDispatch::IntegrationTest
  test "index requires authorization" do
    get api_v1_jobs_url
    assert_response :unauthorized
  end

  test "index returns only the current user's jobs" do
    get api_v1_jobs_url, headers: auth_headers(users(:alice))
    assert_response :success

    ids = JSON.parse(response.body).map { |job| job["id"] }
    assert_includes ids, jobs(:alice_job_applied).id
    assert_includes ids, jobs(:alice_job_interviewing).id
  end

  test "index filters by status" do
    get api_v1_jobs_url(status: "interviewing"), headers: auth_headers(users(:alice))
    assert_response :success

    bodies = JSON.parse(response.body)
    assert_equal 1, bodies.size
    assert_equal "interviewing", bodies.first["status"]
  end

  test "show returns a 404 for another user's job" do
    get api_v1_job_url(jobs(:alice_job_applied)), headers: auth_headers(users(:bob))
    assert_response :not_found
  end

  test "create makes a new job scoped to the current user with tags" do
    assert_difference("Job.count", 1) do
      post api_v1_jobs_url,
        params: {
          company_name: "Initech",
          title: "QA Engineer",
          status: "applied",
          tag_names: ["remote", "new-tag"]
        },
        headers: auth_headers(users(:bob))
    end

    assert_response :created
    body = JSON.parse(response.body)
    assert_equal users(:bob).id, Job.last.user_id
    assert_equal ["new-tag", "remote"], body["tags"].map { |t| t["name"] }.sort
  end

  test "create rejects missing required fields" do
    assert_no_difference("Job.count") do
      post api_v1_jobs_url, params: { title: "" }, headers: auth_headers(users(:alice))
    end

    assert_response :unprocessable_entity
  end

  test "update changes status and stamps responded_at" do
    job = jobs(:alice_job_applied)

    patch api_v1_job_url(job), params: { status: "phone_screen" }, headers: auth_headers(users(:alice))

    assert_response :success
    job.reload
    assert_equal "phone_screen", job.status
    assert_not_nil job.responded_at
  end

  test "destroy removes the job" do
    job = jobs(:alice_job_applied)

    assert_difference("Job.count", -1) do
      delete api_v1_job_url(job), headers: auth_headers(users(:alice))
    end

    assert_response :no_content
  end
end
