class Api::V1::StatsController < ApplicationController
    before_action :authorize!

    def show
        jobs = current_user.jobs

        render json: {
            total_applications: jobs.count,
            by_status: by_status(jobs),
            rates: rates(jobs),
            applications_per_week: applications_per_week(jobs),
            average_days_to_first_response: average_days_to_first_response(jobs),
            by_tag: by_tag(jobs),
            by_company: by_company(jobs),
            by_resume: by_resume(jobs)
        }
    end

    private

    def by_status(jobs)
        Job.statuses.keys.index_with { |status| jobs.where(status: status).count }
    end

    def rates(jobs)
        total = jobs.count
        return { response_rate: 0.0, interview_rate: 0.0, offer_rate: 0.0 } if total.zero?

        responded = jobs.where(status: Job::RESPONDED_STATUSES).count
        interviewed = jobs.where(status: Job::INTERVIEWED_STATUSES).count
        offers = jobs.where(status: "offer").count

        {
            response_rate: pct(responded, total),
            interview_rate: pct(interviewed, total),
            offer_rate: pct(offers, total)
        }
    end

    def applications_per_week(jobs)
        jobs.where.not(applied_date: nil)
            .group("date_trunc('week', applied_date)")
            .count
            .transform_keys { |date| date.to_date.iso8601 }
            .sort
            .to_h
    end

    def average_days_to_first_response(jobs)
        respondable = jobs.where.not(responded_at: nil).where.not(applied_date: nil)
        return nil if respondable.count.zero?

        avg_seconds = respondable.average("EXTRACT(EPOCH FROM (responded_at - applied_date))")
        (avg_seconds.to_f / 86_400).round(1)
    end

    def by_tag(jobs)
        Tag.joins(:jobs).where(jobs: { id: jobs.select(:id) }).group(:name).count
    end

    def by_company(jobs)
        jobs.group(:company_name).count
    end

    def by_resume(jobs)
        jobs.includes(:resume).group_by(&:resume).each_with_object({}) do |(resume, resume_jobs), result|
            key = resume&.name || "No resume"
            total = resume_jobs.size
            responded = resume_jobs.count { |job| Job::RESPONDED_STATUSES.include?(job.status) }
            offers = resume_jobs.count { |job| job.status == "offer" }

            result[key] = {
                total_applications: total,
                response_rate: pct(responded, total),
                offer_rate: pct(offers, total)
            }
        end
    end

    def pct(numerator, denominator)
        return 0.0 if denominator.zero?

        ((numerator.to_f / denominator) * 100).round(1)
    end
end
