class Workout < ApplicationRecord
    has_many :favorites,  dependent: :destroy
    has_many :selections, dependent: :destroy
  
    validates :name, :body_part, :difficulty, :duration, :equipment_required, presence: true
    validates :difficulty, inclusion: { in: %w[beginner intermediate advanced] }
  end
  