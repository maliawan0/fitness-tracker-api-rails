# app/controllers/workouts_controller.rb
class WorkoutsController < ApplicationController
  before_action :authorize_request
  include Rails.application.routes.url_helpers

  def index
    scope = Workout.all
    scope = scope.where(body_part: params[:body_part])          if params[:body_part].present?
    scope = scope.where(difficulty: params[:difficulty])        if params[:difficulty].present?
    scope = scope.where(equipment_required: params[:equipment]) if params[:equipment].present?

    render json: scope.order(created_at: :desc).limit(100).map { |w| workout_json(w) }
  end

  def show
    w = Workout.find(params[:id])
    render json: workout_json(w)
  end

  # Note: Image uploads are restricted to admin users only
  # Regular users cannot upload/update workout images

  private
  def workout_json(w)
    {
      id: w.id, name: w.name, body_part: w.body_part, difficulty: w.difficulty,
      duration: w.duration, equipment_required: w.equipment_required, instructions: w.instructions,
      image_url: (w.image.attached? ? rails_blob_url(w.image, only_path: false, disposition: "inline", expires_in: 10.minutes) : nil)
    }
  end
end
