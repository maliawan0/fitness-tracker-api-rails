class FavouritesController < ApplicationController
  before_action :authorize_request

  # GET /favorites
  def index
    workouts = @current_user.favorite_workouts
                   .select(:id, :name, :body_part, :difficulty, :duration, :equipment_required)
                   .order(:name)
    render json: workouts
  end

  # POST /favorites  { "workout_id": 123 }
  def create
    workout = Workout.find(params[:workout_id])
    @current_user.favorites.find_or_create_by!(workout: workout)
    render json: { message: "favorited", workout_id: workout.id }, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: [e.message] }, status: :unprocessable_entity
  end

  # DELETE /favorites/:workout_id
  def destroy
    fav = @current_user.favorites.find_by(workout_id: params[:workout_id])
    fav&.destroy
    head :no_content
  end
end
