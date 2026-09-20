require 'test_helper'

class TagTest < ActiveSupport::TestCase
  test "invalid without a name" do
    tag = Tag.new(name: nil)
    assert_not tag.valid?
  end

  test "invalid with duplicate name regardless of case" do
    tag = Tag.new(name: "REMOTE")
    assert_not tag.valid?
  end

  test "has many jobs through jobs_tags" do
    assert_includes tags(:remote).jobs, jobs(:alice_job_applied)
  end
end
