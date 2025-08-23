class RegistrationsController < ApplicationController
    def create
      user = User.new(user_params)
      if user.save
        render json: token_pair_for(user), status: :created
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    private
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
  
    def token_pair_for(user)
      access  = JsonWebToken.encode({ sub: user.id, jti: user.jti }, exp: 15.minutes.from_now)
      refresh = JsonWebToken.encode({ sub: user.id, jti: user.jti, typ: "refresh" }, exp: 7.days.from_now)
      { access_token: access, refresh_token: refresh }
    end
  end
  