# app/controllers/recommendations_controller.rb
class RecommendationsController < ApplicationController
  before_action :authorize_request

  # GET /recommendations/trending
  # simple: most selected globally (last 30 days by default)
  def trending
    window_start = (params[:days] || 30).to_i.days.ago

    rows = Selection.where("started_at >= ?", window_start)
           .joins(:workout)
           .group("workouts.id", "workouts.name", "workouts.body_part", "workouts.difficulty")
           .order(Arel.sql("COUNT(selections.id) DESC"))
           .limit(params.fetch(:limit, 10).to_i)
           .count

    data = rows.map do |(wid, name, body_part, difficulty), cnt|
      { workout_id: wid, name:, body_part:, difficulty:, score: cnt }
    end

    render json: data
  end

  # GET /recommendations/personalized
  # Heuristics:
  #  - prioritize user's profile.muscle_focus if set
  #  - boost workouts similar to user's favorites' body_part
  #  - suggest next difficulty (if user often selects beginner, nudge to intermediate)
  def personalized
    limit = params.fetch(:limit, 10).to_i

    profile = @current_user.profile
    favorite_body_parts = @current_user.favorite_workouts.group(:body_part).order(Arel.sql("COUNT(*) DESC")).count.keys
    user_hist = @current_user.selections.joins(:workout)

    # find user's dominant difficulty usage
    diff_counts = user_hist.group("workouts.difficulty").count
    dominant_diff = diff_counts.max_by { |_k, v| v }&.first # "beginner"/"intermediate"/"advanced"
    next_diff = case dominant_diff
                when "beginner" then "intermediate"
                when "intermediate" then "advanced"
                else nil
                end

    # base scope: visible workouts
    scope = Workout.all

    # prioritize by muscle focus
    ordered_ids = []

    if profile&.muscle_focus.present?
      ids = scope.where(body_part: profile.muscle_focus).limit(limit * 2).pluck(:id)
      ordered_ids.concat(ids)
    end

    # boost favorite body parts
    favorite_body_parts.each do |bp|
      ids = scope.where(body_part: bp).limit(limit).pluck(:id)
      ordered_ids.concat(ids)
    end

    # suggest next difficulty if applicable
    if next_diff
      ids = scope.where(difficulty: next_diff).limit(limit).pluck(:id)
      ordered_ids.concat(ids)
    end

    # fallback: trending globally to fill remaining slots
    if ordered_ids.size < limit
      trending_ids = Selection.joins(:workout)
                     .group("workouts.id")
                     .order(Arel.sql("COUNT(selections.id) DESC"))
                     .limit(limit * 2)
                     .count
                     .keys
      ordered_ids.concat(trending_ids)
    end

    # de-dup while preserving order, then fetch
    ordered_ids = ordered_ids.uniq.first(limit)
    recs = Workout.where(id: ordered_ids).index_by(&:id)
    result = ordered_ids.map do |wid|
      w = recs[wid]
      { workout_id: w.id, name: w.name, body_part: w.body_part, difficulty: w.difficulty, duration: w.duration, equipment_required: w.equipment_required }
    end

    render json: result
  end
end
