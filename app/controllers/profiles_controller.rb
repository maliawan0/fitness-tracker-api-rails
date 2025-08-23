class ProfilesController < ApplicationController
  before_action :authorize_request


  def show
    render json: current_profile , status: :ok
  end

  def update
    if current_profile.update(profile_params)
      render json: current_profile, status: :ok
    else
      render json: {errors: current_profile.errors.full_messages}, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:age, :weight, :gender, :goals, :muscle_focus, :intensity)
  end



  def current_profile
    @current_profile ||= (@current_user.profile || @current_user.create_profile!)
  end

end
