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
      render json: workout_json(@workout)
    end

    # POST /admin/workouts
    # { "workout": { "name": "...", "body_part": "...", "difficulty": "beginner",
    #                "duration": 10, "equipment_required": "none", "image_url": null,
    #                "instructions": "..." } }
    def create
      w = Workout.new(workout_params)
      attach_image!(w)
      if w.save
        render json: workout_json(w), status: :created
      else
        render json: { errors: w.errors.full_messages }, status: :unprocessable_entity
      end
    end


    # PATCH/PUT /admin/workouts/:id

    def update
      if params[:image].present?
        # Image-only update
        @workout.image.attach(params[:image])
        if @workout.valid?
          render json: { message: "Image uploaded successfully", workout: workout_json(@workout) }
        else
          render json: { error: @workout.errors.full_messages.join(", ") }, status: :unprocessable_entity
        end
      else
        # Regular workout attributes update
        @workout.assign_attributes(workout_params)
        attach_image!(@workout)
        if @workout.save
          render json: workout_json(@workout), status: :ok
        else
          render json: { errors: @workout.errors.full_messages }, status: :unprocessable_entity
        end
      end
    end

    # DELETE /admin/workouts/:id
    def destroy
      @workout.destroy
      head :no_content
    end

    def showuser 
      user = User.all
      render json: user, status: :ok
    end 


    private

    def set_workout; @workout = Workout.find(params[:id]); end


    def workout_params
      if params[:workout].present?
        params.require(:workout).permit(:name, :body_part, :difficulty, :duration, :equipment_required, :instructions)
      else
        # Allow direct parameters when not nested under :workout
        params.permit(:name, :body_part, :difficulty, :duration, :equipment_required, :instructions)
      end
    end

    def attach_image!(record)
      return unless params[:image].present?
      record.image.attach(params[:image])   # expects multipart/form-data file field "image"
    end

    def workout_json(w)
      {
        id: w.id, name: w.name, body_part: w.body_part, difficulty: w.difficulty,
        duration: w.duration, equipment_required: w.equipment_required, instructions: w.instructions,
        image_url: (w.image.attached? ? rails_blob_url(w.image, only_path: false, disposition: "inline", expires_in: 10.minutes) : nil)
      }
    end
    
    def require_admin!
      return if @current_user&.admin?
      render json: { error: "Forbidden" }, status: :forbidden
    end
  end
end