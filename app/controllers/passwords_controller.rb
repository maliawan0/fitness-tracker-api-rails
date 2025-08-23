class PasswordsController < ApplicationController
  # These actions are unauthenticated (user doesn't have a valid JWT yet)
  skip_before_action :verify_authenticity_token, only: [:forgot, :reset] if defined?(protect_from_forgery)

  # POST /password/forgot

  def forgot
    if params[:email].present?
      if (user = User.find_by(email: params[:email]))
        raw = user.generate_reset_token!
        payload = { message: "If that email exists, a reset link has been sent." }
        payload[:debug_reset_token] = raw unless Rails.env.production?
        return render json: payload, status: :accepted
      end
    end

    render json: { message: "If that email exists, a reset link has been sent." }, status: :accepted
  end

  # POST /password/reset
  # On success: rotates jti (logs out everywhere) and clears reset token.
  def reset
    user = User.find_by(email: reset_params[:email])
    return invalid_token! unless user&.valid_reset_token?(reset_params[:token])

    user.password              = reset_params[:password]
    user.password_confirmation = reset_params[:password_confirmation]

    if user.save
      user.regenerate_jti!    # invalidate all existing JWTs
      user.clear_reset_token! # one-time token
      render json: { message: "Password has been reset successfully." }, status: :ok
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def reset_params
    params.permit(:email, :token, :password, :password_confirmation)
  end

  def invalid_token!
    render json: { error: "Invalid or expired token" }, status: :unauthorized
  end
end
