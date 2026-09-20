require 'test_helper'

class JobTest < ActiveSupport::TestCase
  test "invalid without a company name" do
    job = Job.new(title: "Engineer", user: users(:alice))
    assert_not job.valid?
  end

  test "invalid without a title" do
    job = Job.new(company_name: "Acme", user: users(:alice))
    assert_not job.valid?
  end

  test "defaults to applied status" do
    job = Job.new(company_name: "Acme", title: "Engineer", user: users(:alice))
    assert job.applied?
  end

  test "rejects an unrecognized status" do
    assert_raises(ArgumentError) do
      Job.new(company_name: "Acme", title: "Engineer", user: users(:alice), status: "bogus")
    end
  end

  test "sets responded_at the first time status leaves applied" do
    job = jobs(:alice_job_applied)
    assert_nil job.responded_at

    job.update!(status: :phone_screen)

    assert_not_nil job.responded_at
  end

  test "does not overwrite an existing responded_at" do
    job = jobs(:alice_job_interviewing)
    original_responded_at = job.responded_at

    job.update!(status: :offer)

    assert_equal original_responded_at, job.reload.responded_at
  end
end
