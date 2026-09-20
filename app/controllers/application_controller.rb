class ApplicationController < ActionController::API
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
    rescue_from ArgumentError, with: :render_bad_request

    def encode_token(id)
      JWT.encode({ user_id: id }, jwt_secret, "HS256")
    end

    def get_auth_header
      request.headers["Authorization"]
    end

    def decoded_token
      header = get_auth_header
      return nil unless header

      token = header.split(" ").last
      JWT.decode(token, jwt_secret, true, algorithm: "HS256")[0]["user_id"]
    rescue JWT::DecodeError
      nil
    end

    def current_user
      @current_user ||= User.find_by(id: decoded_token)
    end
    alias session_user current_user

    def logged_in?
      !!current_user
    end

    def authorize!
      render json: { errors: ["Unauthorized"] }, status: :unauthorized unless logged_in?
    end

    private

    def jwt_secret
      Rails.application.secret_key_base
    end

    def render_not_found
      render json: { errors: ["Record not found"] }, status: :not_found
    end

    def render_bad_request(exception)
      render json: { errors: [exception.message] }, status: :unprocessable_entity
    end
end
