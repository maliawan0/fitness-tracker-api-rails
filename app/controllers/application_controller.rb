class ApplicationController < ActionController::API
    rescue_from JWT::ExpiredSignature, with: :unauthorized!
    rescue_from JWT::DecodeError, with: :unauthorized!
  
    private
  
    def authorize_request
      header = request.headers["Authorization"]
      token  = header&.split(" ")&.last
      payload = JsonWebToken.decode(token)
      @current_user = User.find_by(id: payload["sub"])
  
      # jti check for revocation
      if @current_user.nil? || @current_user.jti != payload["jti"]
        return unauthorized!
      end
    rescue StandardError
      unauthorized!
    end
  
    def unauthorized!
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end
  