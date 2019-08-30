# frozen_string_literal: true

class UserPresenter
  attr_reader :user, :auth_token

  def initialize(user, auth_token = nil)
    @user = user
    @auth_token = auth_token
  end

  def _show(options = {})
    response = {
      id: user.id,
      email: user.email,
      role: user.role,
      name: user.name,
      phone_number: user.phone_number,
      address: user.address,
      city: user.city,
      state: user.state
    }
    response[:auth_token] = auth_token.token if options[:auth_token_included]
    response[:reset_password_token] = user.reset_password_token if options[:reset_password_token_included]
    response[:reset_password_token_expire_at] = user.reset_password_token_expire_at if options[:reset_password_token_included]
    response
  end
end
