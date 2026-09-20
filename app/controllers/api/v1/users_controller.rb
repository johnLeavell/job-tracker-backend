class Api::V1::UsersController < ApplicationController
  before_action :authorize!, only: [:profile]

  def create
    user = User.new(
      username: params[:username],
      password: params[:password],
      avatar: params[:avatar]
    )

    if user.save
      token = encode_token(user.id)
      render json: { user: user, token: token }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def profile
    render json: current_user
  end
end
