# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :authenticate_token
  before_action :delete_expired_token

  def authenticate_token
    @auth_token = AuthToken.find_by(token: request.headers['Authorization'])
    render json: { error: 'Invalid token' }, status: :unauthorized unless @auth_token.present?
  end

  def delete_expired_token
    return unless @auth_token.expired?

    @auth_token.delete
    render json: { error: 'Token expired' }, status: :unauthorized
  end
end
