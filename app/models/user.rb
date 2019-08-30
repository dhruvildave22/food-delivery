# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_one :restaurant, foreign_key: :manager_id
  has_many :auth_tokens
  validates :password, presence: true, length: { minimum: 6 }, if: -> { password.present? }
  before_update :clear_auth_tokens, if: -> { password_digest_changed? }
  before_update :clear_reset_password_token, if: -> { password_digest_changed? }
  after_update :trigger_reset_password_email, if: -> { previous_changes.keys.include?('reset_password_token') && reset_password_token }

  def generate_reset_password_token
    update!(reset_password_token: SecureRandom.urlsafe_base64(8), reset_password_token_expire_at: 1.days.from_now)
  end

  def reset_password_token_expired?
    reset_password_token_expire_at < Time.now
  end

  def clear_auth_tokens
    auth_tokens.delete_all
  end

  def clear_reset_password_token
    self.reset_password_token = nil
    self.reset_password_token_expire_at = nil
  end

  private

  def trigger_reset_password_email
    FoodDeliveryApiMailer.send_reset_password_email(self).deliver_now
  end
end
