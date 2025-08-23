class AnalyticsController < ApplicationController
  before_action :authorize_request

  # Global top-N
  def most_selected
    rows = Selection.joins(:workout)
           .group("workouts.id", "workouts.name", "workouts.body_part", "workouts.difficulty")
           .order(Arel.sql("COUNT(selections.id) DESC"))
           .limit(params.fetch(:limit, 10).to_i)
           .count

    data = rows.map { |(wid, name, body_part, difficulty), cnt|
      { workout_id: wid, name:, body_part:, difficulty:, count: cnt }
    }
    render json: data
  end

  # Current user top-N
  def most_selected_me
    rows = @current_user.selections
           .joins(:workout)
           .group("workouts.id", "workouts.name", "workouts.body_part", "workouts.difficulty")
           .order(Arel.sql("COUNT(selections.id) DESC"))
           .limit(params.fetch(:limit, 10).to_i)
           .count

    data = rows.map { |(wid, name, body_part, difficulty), cnt|
      { workout_id: wid, name:, body_part:, difficulty:, count: cnt }
    }
    render json: data
  end
end
