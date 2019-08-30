# frozen_string_literal: true

class AuthToken < ApplicationRecord
  belongs_to :user
  after_initialize :set_defaults

  def set_defaults
    self.token ||= SecureRandom.urlsafe_base64(8)
    self.expire_at ||= 1.days.from_now
  end

  def expired?
    DateTime.current > created_at.advance(days: 1)
  end

  def self.create!(option)
    auth_token = AuthTokenForm.new(option)
    auth_token.persist
    auth_token.object
  end
end
