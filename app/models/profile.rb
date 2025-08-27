class Profile < ApplicationRecord
  belongs_to :user

  validates :intensity, inclusion: { in: %w[low medium high], allow_nil: true }
  validates :gender, inclusion: { in: %w[male female ], allow_nil: true }
end
