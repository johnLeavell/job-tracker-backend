require 'test_helper'

class ResumeTest < ActiveSupport::TestCase
  test "invalid without a name" do
    resume = Resume.new(name: nil, user: users(:alice))
    assert_not resume.valid?
  end

  test "invalid without a user" do
    resume = Resume.new(name: "General v1", user: nil)
    assert_not resume.valid?
  end

  test "nullifies jobs when destroyed" do
    resume = resumes(:alice_resume)
    job = jobs(:alice_job_applied)
    assert_equal resume, job.resume

    resume.destroy

    assert_nil job.reload.resume_id
  end
end
