require 'test_helper'

class JobsTagTest < ActiveSupport::TestCase
  test "invalid without a job" do
    jobs_tag = JobsTag.new(job: nil, tag: tags(:remote))
    assert_not jobs_tag.valid?
  end

  test "invalid without a tag" do
    jobs_tag = JobsTag.new(job: jobs(:alice_job_applied), tag: nil)
    assert_not jobs_tag.valid?
  end

  test "valid with a job and a tag" do
    jobs_tag = JobsTag.new(job: jobs(:alice_job_interviewing), tag: tags(:remote))
    assert jobs_tag.valid?
  end
end
