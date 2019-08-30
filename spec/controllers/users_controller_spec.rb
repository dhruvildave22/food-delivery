# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  before(:each) do
    logged_in_user
    @user = FactoryBot.create(:user)
    request.headers['Authorization'] = @token
  end

  context 'GET role index' do
    it 'should give success if requested role is correct' do
      get :role_index, params: { role: @user.role }, format: :json
      expect(response).to have_http_status(:ok)
    end
    it 'should give users of the requested role if requested role is correct' do
      get :role_index, params: { role: @user.role }, format: :json
      users = JSON.parse(response.body)['users']
      expect(users.map { |user| user['role'] }.uniq).to eq [@user.role]
    end
    it 'should not give users if requested role is incorrect' do
      get :role_index, params: { role: nil }, format: :json
      expect(JSON.parse(response.body)['users']).to be_empty
    end
    it 'should give unauthorized error when request without authorization token' do
      request.headers['Authorization'] = nil
      get :role_index, format: :json
      expect(response).to have_http_status(:unauthorized)
    end
    it 'should give unauthorized error when request with invalid authorization token' do
      request.headers['Authorization'] = Faker::Number.number(digits: 8)
      get :role_index, format: :json
      expect(response).to have_http_status(:unauthorized)
    end
    it 'should give unauthorized error when request with expired authorization token' do
      Timecop.travel(Faker::Date.between(from: 1.day.from_now, to: 1.year.from_now)) do
        get :role_index, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
  context 'POST create' do
    it 'should give success if correct values are passed' do
      user = FactoryBot.build(:user)
      post :create, params: { user: { email: user.email, password: Faker::Alphanumeric.alpha(number: 8), role: user.role, name: user.name, phone_number: user.phone_number, address: user.address, city: user.city, state: user.state } }, format: 'json'
      expect(response).to have_http_status(:ok)
    end
    it 'should give user details if correct values are passed' do
      user = FactoryBot.build(:user)
      post :create, params: { user: { email: user.email, password: Faker::Alphanumeric.alpha(number: 8), role: user.role, name: user.name, phone_number: user.phone_number, address: user.address, city: user.city, state: user.state } }, format: 'json'
      expect(JSON.parse(response.body)['user']['email']).to eq(user.email)
      expect(JSON.parse(response.body)['user']['role']).to eq(user.role)
      expect(JSON.parse(response.body)['user']['name']).to eq(user.name)
      expect(JSON.parse(response.body)['user']['phone_number']).to eq(user.phone_number)
      expect(JSON.parse(response.body)['user']['address']). to eq(user.address)
      expect(JSON.parse(response.body)['user']['city']).to eq(user.city)
      expect(JSON.parse(response.body)['user']['state']).to eq(user.state)
    end
    it 'should give unprocessable entity error if incorrect values are passed' do
      post :create, params: { user: { email: nil, password: nil, role: nil, name: nil, phone_number: nil, address: nil, city: nil, state: nil } }, format: 'json'
      expect(response).to have_http_status(:unprocessable_entity)
    end
    it 'should not create user if auth_token is expired' do
      Timecop.travel(Faker::Date.between(from: 2.days.from_now, to: 1.year.from_now)) do
        user = FactoryBot.build(:user)
        request.headers['Authorization'] = @token
        post :create, params: { user: { email: user.email, password: Faker::Alphanumeric.alpha(number: 8), role: user.role, name: user.name, phone_number: user.phone_number, address: user.address, city: user.city, state: user.state } }, format: 'json'
        expect(response).to have_http_status(:unauthorized)
      end
    end
    it 'should give unauthorized error when request without authorization token' do
      request.headers['Authorization'] = nil
      user = FactoryBot.build(:user)
      post :create, params: { user: { email: user.email, password: Faker::Alphanumeric.alpha(number: 8), role: user.role, name: user.name, phone_number: user.phone_number, address: user.address, city: user.city, state: user.state } }, format: 'json'
      expect(response).to have_http_status(:unauthorized)
    end
    it 'should give unauthorized error when request with invalid authorization token' do
      request.headers['Authorization'] = Faker::Number.number(digits: 8)
      user = FactoryBot.build(:user)
      post :create, params: { user: { email: user.email, password: Faker::Alphanumeric.alpha(number: 8), role: user.role, name: user.name, phone_number: user.phone_number, address: user.address, city: user.city, state: user.state } }, format: 'json'
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'GET show' do
    it 'should give success if requested id is correct' do
      get :show, params: { id: @user.id }, format: 'json'
      expect(JSON.parse(response.body)['user']['id']).to eq(@user.id)
      expect(response).to have_http_status(:ok)
    end
    it 'should give not found error if requested id is incorrect' do
      get :show, params: { id: Faker::Number.number(digits: 8) }, format: 'json'
      expect(response).to have_http_status(:not_found)
    end
    it 'should give user details if correct values are passed' do
      get :show, params: { id: @user.id }, format: 'json'
      expect(JSON.parse(response.body)['user']['id']).to eq(@user.id)
    end
    it 'should not create user if auth_token is expired' do
      Timecop.travel(Faker::Date.between(from: 2.days.from_now, to: 1.year.from_now)) do
        request.headers['Authorization'] = @token
        get :show, params: { id: @user.id }, format: 'json'
        expect(response).to have_http_status(:unauthorized)
      end
    end
    it 'should give unauthorized error when request without authorization token' do
      request.headers['Authorization'] = nil
      get :show, params: { id: @user.id }, format: 'json'
      expect(response).to have_http_status(:unauthorized)
    end
    it 'should give unauthorized error when request with invalid authorization token' do
      request.headers['Authorization'] = Faker::Number.number(digits: 8)
      get :show, params: { id: @user.id }, format: 'json'
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'PUT update' do
    it 'should give success if correct values are passed' do
      user1 = FactoryBot.build(:user)
      put :update, params: { id: @user.id, user: { email: user1.email, password: Faker::Alphanumeric.alpha(number: 8), role: user1.role, name: user1.name, phone_number: user1.phone_number, address: user1.address, city: user1.city, state: user1.state } }, format: 'json'
      expect(response).to have_http_status(:ok)
    end
    it 'should give not found error if requested id is incorrect' do
      user1 = FactoryBot.build(:user)
      put :update, params: { id: Faker::Number.number(digits: 8), user: { email: user1.email, password: Faker::Alphanumeric.alpha(number: 8), role: user1.role, name: user1.name, phone_number: user1.phone_number, address: user1.address, city: user1.city, state: user1.state } }, format: 'json'
      expect(response).to have_http_status(:not_found)
    end
    it 'should give user details if correct values are passed' do
      user1 = FactoryBot.build(:user)
      put :update, params: { id: @user.id, user: { email: user1.email, password: Faker::Alphanumeric.alpha(number: 8), role: user1.role, name: user1.name, phone_number: user1.phone_number, address: user1.address, city: user1.city, state: user1.state } }, format: 'json'
      expect(JSON.parse(response.body)['user']['id']).to eq(@user.id)
      expect(JSON.parse(response.body)['user']['email']).to eq(user1.email)
      expect(JSON.parse(response.body)['user']['role']).to eq(user1.role)
      expect(JSON.parse(response.body)['user']['name']).to eq(user1.name)
      expect(JSON.parse(response.body)['user']['phone_number']).to eq(user1.phone_number)
      expect(JSON.parse(response.body)['user']['address']). to eq(user1.address)
      expect(JSON.parse(response.body)['user']['city']).to eq(user1.city)
      expect(JSON.parse(response.body)['user']['state']).to eq(user1.state)
    end
    it 'should give unprocessable entity error if incorrect values are passed' do
      put :update, params: { id: @user.id, user: { email: nil, role: nil, name: nil, phone_number: nil, address: nil, city: nil, state: nil } }, format: 'json'
      expect(response).to have_http_status(:unprocessable_entity)
    end
    it 'should not create user if auth_token is expired' do
      Timecop.travel(Faker::Date.between(from: 2.days.from_now, to: 1.year.from_now)) do
        request.headers['Authorization'] = @token
        put :update, params: { id: @user.id, user: { email: nil, role: nil, name: nil, phone_number: nil, address: nil, city: nil, state: nil } }, format: 'json'
        expect(response).to have_http_status(:unauthorized)
      end
    end
    it 'should give unauthorized error when request without authorization token' do
      request.headers['Authorization'] = nil
      put :update, params: { id: @user.id, user: { email: nil, role: nil, name: nil, phone_number: nil, address: nil, city: nil, state: nil } }, format: 'json'
      expect(response).to have_http_status(:unauthorized)
    end
    it 'should give unauthorized error when request with invalid authorization token' do
      request.headers['Authorization'] = Faker::Number.number(digits: 8)
      put :update, params: { id: @user.id, user: { email: nil, role: nil, name: nil, phone_number: nil, address: nil, city: nil, state: nil } }, format: 'json'
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'PUT reset_password' do
    it 'should give success if reset password token is correct' do
      @user.generate_reset_password_token
      put :reset_password, params: { reset_password_token: @user.reset_password_token, user: { password: Faker::Alphanumeric.alpha(number: 8) } }, format: 'json'
      expect(response).to have_http_status(:ok)
    end
    it 'should give unprocessable entity if password is incorrect' do
      @user.generate_reset_password_token
      put :reset_password, params: { reset_password_token: @user.reset_password_token, user: { password: Faker::Alphanumeric.alpha(number: 4) } }, format: 'json'
      expect(response).to have_http_status(:unprocessable_entity)
    end
    it 'should give not_found error if reset password token is incorrect' do
      @user.generate_reset_password_token
      put :reset_password, params: { reset_password_token: Faker::Alphanumeric.alpha(number: 8), user: { password: Faker::Alphanumeric.alpha(number: 8) } }, format: 'json'
      expect(response).to have_http_status(:not_found)
    end
    it 'should give unauthorized error if reset password token is expired' do
      @user.generate_reset_password_token
      Timecop.travel(Faker::Date.between(from: 2.days.from_now, to: 1.year.from_now)) do
        put :reset_password, params: { reset_password_token: @user.reset_password_token, user: { password: Faker::Alphanumeric.alpha(number: 8) } }, format: 'json'
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
