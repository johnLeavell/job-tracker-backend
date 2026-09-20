require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "valid with username and password" do
    user = User.new(username: "carol", password: "password")
    assert user.valid?
  end

  test "invalid without username" do
    user = User.new(username: nil, password: "password")
    assert_not user.valid?
  end

  test "invalid with duplicate username regardless of case" do
    user = User.new(username: "ALICE", password: "password")
    assert_not user.valid?
  end

  test "authenticates with correct password" do
    user = users(:alice)
    assert user.authenticate("password")
    assert_not user.authenticate("wrong")
  end

  test "has many jobs and resumes" do
    assert_includes users(:alice).jobs, jobs(:alice_job_applied)
    assert_includes users(:alice).resumes, resumes(:alice_resume)
  end
end
