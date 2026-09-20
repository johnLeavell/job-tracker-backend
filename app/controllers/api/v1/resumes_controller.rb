class Api::V1::ResumesController < ApplicationController
    before_action :authorize!
    before_action :set_resume, only: [:show, :update, :destroy]

    def index
        render json: current_user.resumes.order(:name)
    end

    def show
        render json: @resume
    end

    def create
        resume = current_user.resumes.new(resume_params)

        if resume.save
            render json: resume, status: :created
        else
            render json: { errors: resume.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def update
        if @resume.update(resume_params)
            render json: @resume
        else
            render json: { errors: @resume.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def destroy
        @resume.destroy
        head :no_content
    end

    private

    def set_resume
        @resume = current_user.resumes.find(params[:id])
    end

    def resume_params
        params.permit(:name)
    end
end
