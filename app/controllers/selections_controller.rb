class SelectionsController < ApplicationController
  before_action :authorize_request

  # GET /selections  (current user's history, newest first)
  def index
    history = @current_user.selections
               .includes(:workout)
               .order(started_at: :desc)
               .limit(200)

    render json: history.as_json(
      only: [:id, :started_at, :completed_at, :duration_seconds],
      include: { workout: { only: [:id, :name, :body_part, :difficulty, :duration] } }
    )
  end

  # POST /selections { "workout_id": 123, "started_at": "...", "completed_at": "...", "duration_seconds": 600 }
  def create
    workout = Workout.find(params[:workout_id])
    sel = @current_user.selections.create!(
      workout: workout,
      started_at: params[:started_at] || Time.current,
      completed_at: params[:completed_at],
      duration_seconds: params[:duration_seconds]
    )
    render json: sel, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: [e.message] }, status: :unprocessable_entity
  end
end
