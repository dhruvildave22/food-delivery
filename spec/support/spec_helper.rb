# frozen_string_literal: true

module SpecHelper
  def logged_in_user
    user_attributes = FactoryBot.build(:user).attributes
    user_attributes.delete('password_digest')
    @current_user = UserForm.new(user_attributes.merge('password' => Faker::Alphanumeric.alpha(number: 8)))
    @current_user.persist
    @current_user = @current_user.object
    @auth_token = AuthTokenForm.new(FactoryBot.build(:auth_token, user_id: @current_user.id).attributes)
    @auth_token.persist
    @token = @auth_token.token
  end
end
