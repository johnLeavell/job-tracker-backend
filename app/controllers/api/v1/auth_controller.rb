class Api::V1::AuthController < ApplicationController
  def login
    user = User.find_by(username: params[:username])

    if user && user.authenticate(params[:password])
      token = encode_token(user.id)
      render json: { user: user, token: token }
    else
      render json: { errors: ["Incorrect username or password"] }, status: :unauthorized
    end
  end

  def auto_login
    if logged_in?
      render json: current_user
    else
      render json: { errors: ["User not found"] }, status: :unauthorized
    end
  end
end
