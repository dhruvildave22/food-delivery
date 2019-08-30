# frozen_string_literal: true

class FoodDeliveryApiMailer < ApplicationMailer
  default from: FoodDeliveryApi.credentials[:smtp_email]

  def send_reset_password_email(user)
    @username = user.email
    @reset_password_email = FoodDeliveryApi.credentials[:host_url] + '/reset-password#' + user.reset_password_token
    mail(to: @username, subject: 'Reset Password')
  end
end
