module Admin
  class WorkoutsController < ApplicationController
    before_action :authorize_request
    before_action :require_admin!
    before_action :set_workout, only: [:show, :update, :destroy]

    # GET /admin/workouts
    def index
      scope = Workout.all
      scope = scope.where(body_part: params[:body_part]) if params[:body_part].present?
      scope = scope.where(difficulty: params[:difficulty]) if params[:difficulty].present?
      scope = scope.where(equipment_required: params[:equipment]) if params[:equipment].present?
      render json: scope.order(created_at: :desc).limit(200), status: :ok
    end

    # GET /admin/workouts/:id
    def show
      render json: @workout, status: :ok
    end

    # POST /admin/workouts
    # { "workout": { "name": "...", "body_part": "...", "difficulty": "beginner",
    #                "duration": 10, "equipment_required": "none", "image_url": null,
    #                "instructions": "..." } }
    def create
      w = Workout.new(workout_params)
      if w.save
        render json: w, status: :created
      else
        render json: { errors: w.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /admin/workouts/:id
    def update
      if @workout.update(workout_params)
        render json: @workout, status: :ok
      else
        render json: { errors: @workout.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # DELETE /admin/workouts/:id
    def destroy
      @workout.destroy
      head :no_content
    end

    private

    def set_workout
      @workout = Workout.find(params[:id])
    end

    def workout_params
      params.require(:workout).permit(
        :name, :body_part, :difficulty, :duration,
        :equipment_required, :image_url, :instructions
      )
    end

    def require_admin!
      return if @current_user&.admin?
      render json: { error: "Forbidden" }, status: :forbidden
    end
  end
end
