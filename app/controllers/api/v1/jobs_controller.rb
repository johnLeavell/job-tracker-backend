class Api::V1::JobsController < ApplicationController
    before_action :authorize!
    before_action :set_job, only: [:show, :update, :destroy]

    def index
        jobs = current_user.jobs
        jobs = jobs.where(status: params[:status]) if params[:status].present?
        render json: jobs.order(applied_date: :desc, created_at: :desc), include: [:tags, :resume]
    end

    def show
        render json: @job, include: [:tags, :resume]
    end

    def create
        job = current_user.jobs.new(job_params)

        if job.save
            assign_tags(job)
            render json: job, include: [:tags, :resume], status: :created
        else
            render json: { errors: job.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def update
        if @job.update(job_params)
            assign_tags(@job)
            render json: @job, include: [:tags, :resume]
        else
            render json: { errors: @job.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def destroy
        @job.destroy
        head :no_content
    end

    private

    def set_job
        @job = current_user.jobs.find(params[:id])
    end

    def job_params
        params.permit(:company_name, :title, :status, :applied_date, :notes, :resume_id)
    end

    def assign_tags(job)
        return unless params[:tag_names]

        names = Array(params[:tag_names]).map { |name| name.to_s.strip.downcase }.reject(&:blank?)
        job.tags = names.map { |name| Tag.find_or_create_by(name: name) }
    end
end
