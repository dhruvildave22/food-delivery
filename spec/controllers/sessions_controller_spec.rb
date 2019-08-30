# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  before(:each) do
    logged_in_user
    @user = FactoryBot.create(:user)
    request.headers['Authorization'] = @token
  end
  context 'POST login' do
    it 'should give success when request for correct user with valid credentials' do
      post :login, params: { user: { email: @user.email, password: @user.password } }, format: 'json'
      expect(response).to have_http_status(:ok)
    end
    it 'should give correct user details when request for correct user with valid credentials' do
      post :login, params: { user: { email: @user.email, password: @user.password } }, format: 'json'
      expect(JSON.parse(response.body)['user']['id']).to eq @user.id
      expect(JSON.parse(response.body)['user']['email']).to eq @user.email
      expect(JSON.parse(response.body)['user']['role']).to eq @user.role
      expect(JSON.parse(response.body)['user']['name']).to eq @user.name
      expect(JSON.parse(response.body)['user']['phone_number']).to eq @user.phone_number
      expect(JSON.parse(response.body)['user']['address']). to eq @user.address
      expect(JSON.parse(response.body)['user']['city']).to eq @user.city
      expect(JSON.parse(response.body)['user']['state']).to eq @user.state
    end
    it 'should give unauthorized error when request for correct user with invalid credentials' do
      post :login, params: { user: { email: @user.email, password: Faker::Alphanumeric.alpha(number: 8) } }, format: 'json'
      expect(response).to have_http_status(:unauthorized)
    end
    it 'should not give unauthorized error when request without authorization token' do
      request.headers['Authorization'] = nil
      post :login, params: { user: { email: @user.email, password: @user.password } }, format: 'json'
      expect(response).not_to have_http_status(:unauthorized)
    end
    it 'should not give unauthorized error when request with invalid authorization token' do
      request.headers['Authorization'] = Faker::Number.number(digits: 8)
      post :login, params: { user: { email: @user.email, password: @user.password } }, format: 'json'
      expect(response).not_to have_http_status(:unauthorized)
    end
    it 'should not give unauthorized error when request with expired authorization token' do
      Timecop.travel(Faker::Date.between(from: 1.day.from_now, to: 1.year.from_now)) do
        request.headers['Authorization'] = @auth_token
        post :login, params: { user: { email: @user.email, password: @user.password } }, format: 'json'
        expect(response).not_to have_http_status(:unauthorized)
      end
    end
    it 'should generate a auth token for the user if user is valid' do
      post :login, params: { user: { email: @user.email, password: @user.password } }, format: 'json'
      expect(JSON.parse(response.body)['user']['auth_token']).not_to eq nil
    end
  end

  context 'DELETE logout' do
    it 'should destroy the auth token of the user if authororization token if valid' do
      delete :logout
      expect(AuthToken.find_by(token: @token)).to eq nil
    end
    it 'should give unauthorized error when request without authorization token' do
      request.headers['Authorization'] = nil
      delete :logout
      expect(response).to have_http_status(:unauthorized)
    end
    it 'should give unauthorized error when request with invalid authorization token' do
      request.headers['Authorization'] = Faker::Number.number(digits: 8)
      delete :logout
      expect(response).to have_http_status(:unauthorized)
    end
    it 'should give unauthorized error when request with expired authorization token' do
      Timecop.travel(Faker::Date.between(from: 1.day.from_now, to: 1.year.from_now)) do
        request.headers['Authorization'] = @token
        delete :logout
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  context 'PUT forgot_password' do
    it 'should give succcess if email is correct' do
      put :forgot_password, params: { user: { email: @user.email } }, format: 'json'
      expect(response).to have_http_status(:ok)
    end
    it 'should generate the reset password token if email is correct' do
      Timecop.freeze do
        put :forgot_password, params: { user: { email: @user.email } }, format: 'json'
        expect(@user.reload.reset_password_token).not_to eq nil
        expect(@user.reload.reset_password_token_expire_at).to eq 1.days.from_now
      end
    end
    it 'should give not found error if email is incorrect' do
      put :forgot_password, params: { user: { email: Faker::Internet.email } }, format: 'json'
      expect(response).to have_http_status(:not_found)
    end
    it 'should send reset password email if email is correct' do
      copy = double
      expect(FoodDeliveryApiMailer).to(receive(:send_reset_password_email).with(@user).and_return(copy)) && expect(copy).to(receive(:deliver_now))
      put :forgot_password, params: { user: { email: @user.email } }, format: 'json'
    end
  end
end
