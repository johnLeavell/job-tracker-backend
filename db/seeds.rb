# This file should contain all the record creation needed to seed the database with its default values.
# Load with `rails db:seed`.

JobsTag.destroy_all
Job.destroy_all
Resume.destroy_all
Tag.destroy_all
User.destroy_all

user = User.create!(username: "demo", password: "password")

resumes = [
  Resume.create!(name: "Backend Engineer v1", user: user),
  Resume.create!(name: "Full Stack Generalist v2", user: user)
]

tag_names = %w[remote onsite hybrid backend frontend full-stack startup enterprise]
tags = tag_names.map { |name| Tag.create!(name: name) }

statuses = Job.statuses.keys
weighted_statuses = statuses + %w[applied applied rejected rejected]

40.times do
  applied_date = Faker::Date.between(from: 90.days.ago, to: Date.today)
  status = weighted_statuses.sample

  job = Job.new(
    company_name: Faker::Company.name,
    title: Faker::Job.title,
    status: status,
    applied_date: applied_date,
    notes: [nil, Faker::Lorem.sentence].sample,
    user: user,
    resume: resumes.sample
  )
  job.save!

  # Backdate responded_at so it lands after applied_date for jobs that moved past "applied".
  job.update_column(:responded_at, applied_date + rand(1..14).days) if status != "applied"

  job.tags = tags.sample(rand(1..3))
end

puts "Seeded #{User.count} user, #{Resume.count} resumes, #{Tag.count} tags, and #{Job.count} jobs."
puts "Login with username: demo / password: password"
