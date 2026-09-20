class Api::V1::JobsTagsController < ApplicationController
    before_action :authorize!

    def index
        jobs_tags = JobsTag.joins(:job).where(jobs: { user_id: current_user.id })
        render json: jobs_tags, include: [:job, :tag]
    end

    def create
        job = current_user.jobs.find(params[:job_id])
        tag = Tag.find(params[:tag_id])
        jobs_tag = JobsTag.find_or_create_by(job: job, tag: tag)

        if jobs_tag.persisted?
            render json: jobs_tag, status: :created
        else
            render json: { errors: jobs_tag.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def destroy
        jobs_tag = JobsTag.joins(:job).where(jobs: { user_id: current_user.id }).find(params[:id])
        jobs_tag.destroy
        head :no_content
    end
end
