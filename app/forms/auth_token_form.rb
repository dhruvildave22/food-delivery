# frozen_string_literal: true

class AuthTokenForm
  include ActiveModel::Model

  attr_accessor :id, :user_id, :expire_at, :token, :created_at, :updated_at, :object

  validates :user_id, :expire_at, :token, presence: true
  validate :unique_token

  def initialize(option = {}, id = nil)
    @object = id.nil? ? AuthToken.new : AuthToken.find(id)
    @object.attributes = option
    super(object.attributes)
  end

  def persist
    raise errors.full_messages.first unless valid?

    object.save!
  end

  private

  def unique_token
    errors.add(:token, :taken) if AuthToken.where(token: token).any?
  end
end
