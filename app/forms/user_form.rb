# frozen_string_literal: true

class UserForm
  include ActiveModel::Model
  include UserAttributes

  attr_accessor :id, :email, :password_digest, :role, :name, :phone_number, :city, :state, :address, :reset_password_token, :reset_password_token_expire_at, :created_at, :updated_at, :object

  validates :name, :phone_number, :city, :state, :address, presence: true, if: -> { DETAILED_INFO_ROLES.include?(role) }
  validates :email, :role, presence: true
  validate :unique_email_address
  validate :unique_phone_number, if: -> { DETAILED_INFO_ROLES.include?(role) }
  validates :role, inclusion: { in: ROLES }

  def unique_email_address
    errors.add(:email, :taken) if User.where(email: email).any?
  end

  def unique_phone_number
    errors.add(:phone_number, :taken) if User.where(phone_number: phone_number).any?
  end

  def initialize(option = {}, id = nil)
    @object = id.nil? ? User.new : User.find(id)
    @object.attributes = option
    super(@object.attributes)
  end

  def persist
    raise errors.full_messages.first unless valid?

    object.save!
  end
end
