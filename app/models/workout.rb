# app/models/workout.rb
class Workout < ApplicationRecord
  has_one_attached :image

  validates :name, :body_part, :difficulty, :duration, :equipment_required, presence: true
  validates :difficulty, inclusion: { in: %w[beginner intermediate advanced] }

  validate :image_validation

  private
  def image_validation
    return unless image.attached?
    if image.byte_size > 5.megabytes
      errors.add(:image, "is too large (max 5MB)")
    end
    unless image.content_type&.start_with?("image/")
      errors.add(:image, "must be an image")
    end
  end
end