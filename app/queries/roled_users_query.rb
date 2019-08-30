# frozen_string_literal: true

class RoledUsersQuery
  attr_accessor :user, :role

  def initialize(role, users = User.all)
    @user = users
    @role = role
  end

  def all
    @user.where(role: role)
  end
end
