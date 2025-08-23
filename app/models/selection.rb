class Selection < ApplicationRecord
  belongs_to :user
  belongs_to :workout
  validates :started_at, presence: true
end
