class SessionsController < ApplicationController
    def create
      user = User.find_by(email: params[:email])
      if user&.authenticate(params[:password])
        render json: token_pair_for(user), status: :ok
      else
        render json: { error: "Invalid credentials" }, status: :unauthorized
      end
    end
  
    # rotation-style logout: bump jti so old tokens die
    def destroy
      authorize_request
      @current_user.regenerate_jti!
      head :no_content
    end
  
    def refresh
      token = params[:refresh_token]
      payload = JsonWebToken.decode(token)
  
      # must be refresh type
      return render json: { error: "Invalid token type" }, status: :unauthorized unless payload["typ"] == "refresh"
  
      user = User.find_by(id: payload["sub"])
      return render json: { error: "Unauthorized" }, status: :unauthorized if user.nil? || user.jti != payload["jti"]
  
      # optional: rotate jti on refresh to harden
      user.regenerate_jti!
  
      access  = JsonWebToken.encode({ sub: user.id, jti: user.jti }, exp: 15.minutes.from_now)
      refresh = JsonWebToken.encode({ sub: user.id, jti: user.jti, typ: "refresh" }, exp: 7.days.from_now)
  
      render json: { access_token: access, refresh_token: refresh }, status: :ok
    rescue StandardError
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  
    private
  
    def token_pair_for(user)
      access  = JsonWebToken.encode({ sub: user.id, jti: user.jti }, exp: 15.minutes.from_now)
      refresh = JsonWebToken.encode({ sub: user.id, jti: user.jti, typ: "refresh" }, exp: 7.days.from_now)
      { access_token: access, refresh_token: refresh }
    end
  end
  