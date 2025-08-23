class WorkoutsController < ApplicationController
  # before_action :authorize_request

  # GET /workouts?body_part=chest&difficulty=beginner&equipment=none
  def index
    scope = Workout.all
    scope = scope.where(body_part: params[:body_part])               if params[:body_part].present?
    scope = scope.where(difficulty: params[:difficulty])             if params[:difficulty].present?
    scope = scope.where(equipment_required: params[:equipment])      if params[:equipment].present?
    render json: scope.order(created_at: :desc).limit(100)
  end

  # GET /workouts/:id
  def show
    render json: Workout.find(params[:id])
  end
end
