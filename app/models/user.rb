class User < ApplicationRecord
    has_secure_password    #use to store password in database by hashing it and using bcrypt gem

    has_one :profile, dependent: :destroy
    has_many :favorites, dependent: :destroy
    has_many :favorite_workouts, through: :favorites, source: :workout
    has_many :selections, dependent: :destroy

    before_create :set_jti
    validates :email, presence: true, uniqueness: true
  
    # == Password reset ==
  
    # Generates a raw token, stores only its BCrypt digest + timestamp.
    # Returns the RAW token (send via email / show only in dev).
    def generate_reset_token!
      raw = SecureRandom.urlsafe_base64(32)
      self.reset_digest  = digest(raw)
      self.reset_sent_at = Time.current
      save!(validate: false)
      raw
    end
  
    # Verifies the RAW token against the stored BCrypt digest and TTL.
    def valid_reset_token?(raw)
      return false if reset_digest.blank?
      return false if reset_expired?
      BCrypt::Password.new(reset_digest).is_password?(raw)
    rescue BCrypt::Errors::InvalidHash
      false
    end
  
    # Reset token expires after 2 hours (adjust as needed)
    def reset_expired?
      reset_sent_at.blank? || reset_sent_at < 2.hours.ago
    end
  
    # Wipes reset fields (skip validations/callbacks intentionally)
    def clear_reset_token!
      update_columns(reset_digest: nil, reset_sent_at: nil)
    end
  
    # Rotate JTI to invalidate all existing JWTs for this user
    def regenerate_jti!
      update!(jti: SecureRandom.uuid)
    end
  
    private
  
    # BCrypt-hash helper (same cost strategy as has_secure_password)
    def digest(str)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(str, cost: cost)
    end
  
    def set_jti
      self.jti = SecureRandom.uuid
    end
  end
  