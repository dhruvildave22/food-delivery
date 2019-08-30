# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :authenticate_token, :delete_expired_token, only: %i[login forgot_password]
  before_action :exists, except: [:logout]
  before_action :authenticate_user, :generate_auth_token, only: [:login]

  def login
    render json: { user: UserPresenter.new(@user, @auth_token)._show(auth_token_included: true) }, status: :ok
  end

  def logout
    @auth_token.destroy
    render json: {}, status: :ok
  end

  def forgot_password
    @user.generate_reset_password_token
    render json: { user: UserPresenter.new(@user)._show(reset_password_token_included: true) }, status: :ok
  end

  private

  def generate_auth_token
    @auth_token = AuthToken.create!(user_id: @user.id)
  end

  def authenticate_user
    render json: { error: 'Invalid credentials' }, status: :unauthorized unless @user.authenticate(user_params[:password])
  end

  def exists
    @user = User.find_by(email: user_params[:email])
    render json: { error: 'User not found' }, status: :not_found unless @user.present?
  end

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
