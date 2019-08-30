# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RestaurantsController, type: :controller do
  before(:each) do
    logged_in_user
    @user = FactoryBot.create(:user)
    request.headers['Authorization'] = @token
    @restaurant = FactoryBot.create(:restaurant, manager: @user)
  end
  context 'GET index' do
    it 'should give success if authorization token is valid' do
      get :index, format: :json
      expect(response).to have_http_status(:ok)
    end
    it 'should give restaurants if authorization token is valid' do
      get :index, format: :json
      expect(JSON.parse(response.body)['restaurants'].map { |b| b['id'] }).to include @restaurant.id
    end
    it 'should give unauthorized error when request without authorization token' do
      request.headers['Authorization'] = nil
      get :index, format: :json
      expect(response).to have_http_status(:unauthorized)
    end
    it 'should give unauthorized error when request with invalid authorization token' do
      request.headers['Authorization'] = Faker::Number.number(digits: 8)
      get :index, format: :json
      expect(response).to have_http_status(:unauthorized)
    end
    it 'should give unauthorized error when request with expired authorization token' do
      Timecop.travel(Faker::Date.between(from: 1.day.from_now, to: 1.year.from_now)) do
        get :index, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
  context 'POST create' do
    it 'should give success if correct values are passed' do
      restaurant = FactoryBot.build(:restaurant, manager: @user)
      post :create, params: { restaurant: { name: restaurant.name, address: restaurant.address, area: restaurant.area, city: restaurant.city, state: restaurant.state, rating: restaurant.rating, average_delivery_time: restaurant.average_delivery_time, average_cost_per_two: restaurant.average_cost_per_two, manager_id: restaurant.manager_id } }
      expect(response).to have_http_status(:ok)
    end
    it 'should give restaurant details if correct values are passed' do
      restaurant = FactoryBot.build(:restaurant, manager: @user)
      post :create, params: { restaurant: { name: restaurant.name, address: restaurant.address, area: restaurant.area, city: restaurant.city, state: restaurant.state, rating: restaurant.rating, average_delivery_time: restaurant.average_delivery_time, average_cost_per_two: restaurant.average_cost_per_two, manager_id: restaurant.manager_id } }
      expect(JSON.parse(response.body)['restaurant']['name']).to eq(restaurant.name)
      expect(JSON.parse(response.body)['restaurant']['address']).to eq(restaurant.address)
      expect(JSON.parse(response.body)['restaurant']['area']).to eq(restaurant.area)
      expect(JSON.parse(response.body)['restaurant']['city']).to eq(restaurant.city)
      expect(JSON.parse(response.body)['restaurant']['state']).to eq(restaurant.state)
      expect(JSON.parse(response.body)['restaurant']['rating']).to eq(restaurant.rating.to_f.to_s)
      expect(JSON.parse(response.body)['restaurant']['average_cost_per_two']).to eq(restaurant.average_cost_per_two)
      expect(JSON.parse(response.body)['restaurant']['average_delivery_time']).to eq(restaurant.average_delivery_time)
      expect(JSON.parse(response.body)['restaurant']['manager_id']).to eq(restaurant.manager_id)
    end
    it 'should give unprocessable entity error if incorrect values are passed' do
      post :create, params: { restaurant: { name: nil, address: nil, area: nil, city: nil, state: nil, rating: nil, average_delivery_time: nil, average_cost_per_two: nil, manager_id: nil } }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'should give unauthorized error when request without authorization token' do
      request.headers['Authorization'] = nil
      post :create, params: { restaurant: { name: @restaurant.name, address: @restaurant.address, area: @restaurant.area, city: @restaurant.city, state: @restaurant.state, rating: @restaurant.rating, average_delivery_time: @restaurant.average_delivery_time, average_cost_per_two: @restaurant.average_cost_per_two, manager_id: @restaurant.manager_id } }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'should give unauthorized error when request with invalid authorization token' do
      request.headers['Authorization'] = Faker::Number.number(digits: 8)
      post :create, params: { restaurant: { name: @restaurant.name, address: @restaurant.address, area: @restaurant.area, city: @restaurant.city, state: @restaurant.state, rating: @restaurant.rating, average_delivery_time: @restaurant.average_delivery_time, average_cost_per_two: @restaurant.average_cost_per_two, manager_id: @restaurant.manager_id } }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'should give unauthorized error when request with expired authorization token' do
      Timecop.travel(Faker::Date.between(from: 1.day.from_now, to: 1.year.from_now)) do
        post :create, params: { restaurant: { name: @restaurant.name, address: @restaurant.address, area: @restaurant.area, city: @restaurant.city, state: @restaurant.state, rating: @restaurant.rating, average_delivery_time: @restaurant.average_delivery_time, average_cost_per_two: @restaurant.average_cost_per_two, manager_id: @restaurant.manager_id } }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  context 'GET show' do
    it 'should give success if requested id is correct' do
      get :show, params: { id: @restaurant.id }, format: 'json'
      expect(JSON.parse(response.body)['restaurant']['id']).to eq(@restaurant.id)
      expect(response).to have_http_status(:ok)
    end
    it 'should give not found error if requested id is incorrect' do
      get :show, params: { id: Faker::Number.number(digits: 8) }, format: 'json'
      expect(response).to have_http_status(:not_found)
    end
    it 'should give restaurant details if correct values are passed' do
      get :show, params: { id: @restaurant.id }, format: 'json'
      expect(JSON.parse(response.body)['restaurant']['name']).to eq(@restaurant.name)
      expect(JSON.parse(response.body)['restaurant']['address']).to eq(@restaurant.address)
      expect(JSON.parse(response.body)['restaurant']['area']).to eq(@restaurant.area)
      expect(JSON.parse(response.body)['restaurant']['city']).to eq(@restaurant.city)
      expect(JSON.parse(response.body)['restaurant']['state']).to eq(@restaurant.state)
      expect(JSON.parse(response.body)['restaurant']['rating']).to eq(@restaurant.rating.to_f.to_s)
      expect(JSON.parse(response.body)['restaurant']['average_cost_per_two']).to eq(@restaurant.average_cost_per_two)
      expect(JSON.parse(response.body)['restaurant']['average_delivery_time']).to eq(@restaurant.average_delivery_time)
      expect(JSON.parse(response.body)['restaurant']['manager_id']).to eq(@restaurant.manager_id)
    end
    it 'should give unauthorized error when request without authorization token' do
      request.headers['Authorization'] = nil
      get :show, params: { id: @restaurant.id }, format: 'json'
      expect(response).to have_http_status(:unauthorized)
    end
    it 'should give unauthorized error when request with invalid authorization token' do
      request.headers['Authorization'] = Faker::Number.number(digits: 8)
      get :show, params: { id: @restaurant.id }, format: 'json'
      expect(response).to have_http_status(:unauthorized)
    end
    it 'should give unauthorized error when request with expired authorization token' do
      Timecop.travel(Faker::Date.between(from: 1.day.from_now, to: 1.year.from_now)) do
        get :show, params: { id: @restaurant.id }, format: 'json'
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  context 'PUT update' do
    it 'should give success if correct values are passed' do
      restaurant = FactoryBot.create(:restaurant, manager: @user)
      put :update, params: { id: @restaurant.id, restaurant: { name: restaurant.name, address: restaurant.address, area: restaurant.area, city: restaurant.city, state: restaurant.state, rating: restaurant.rating, average_delivery_time: restaurant.average_delivery_time, average_cost_per_two: restaurant.average_cost_per_two, manager_id: restaurant.manager_id } }
      expect(response).to have_http_status(:ok)
    end
    it 'should give not found error if requested id is incorrect' do
      restaurant = FactoryBot.create(:restaurant, manager: @user)
      put :update, params: { id: Faker::Number.number, restaurant: { name: restaurant.name, address: restaurant.address, area: restaurant.area, city: restaurant.city, state: restaurant.state, rating: restaurant.rating, average_delivery_time: restaurant.average_delivery_time, average_cost_per_two: restaurant.average_cost_per_two, manager_id: restaurant.manager_id } }
      expect(response).to have_http_status(:not_found)
    end
    it 'should give restaurant details if correct values are passed' do
      restaurant = FactoryBot.build(:restaurant, manager: @user)
      put :update, params: { id: @restaurant.id, restaurant: { name: restaurant.name, address: restaurant.address, area: restaurant.area, city: restaurant.city, state: restaurant.state, rating: restaurant.rating, average_delivery_time: restaurant.average_delivery_time, average_cost_per_two: restaurant.average_cost_per_two, manager_id: restaurant.manager_id } }
      expect(JSON.parse(response.body)['restaurant']['id']).to eq(@restaurant.id)
      expect(JSON.parse(response.body)['restaurant']['name']).to eq(restaurant.name)
      expect(JSON.parse(response.body)['restaurant']['address']).to eq(restaurant.address)
      expect(JSON.parse(response.body)['restaurant']['area']).to eq(restaurant.area)
      expect(JSON.parse(response.body)['restaurant']['city']).to eq(restaurant.city)
      expect(JSON.parse(response.body)['restaurant']['state']).to eq(restaurant.state)
      expect(JSON.parse(response.body)['restaurant']['rating']).to eq(restaurant.rating.to_f.to_s)
      expect(JSON.parse(response.body)['restaurant']['average_cost_per_two']).to eq(restaurant.average_cost_per_two)
      expect(JSON.parse(response.body)['restaurant']['average_delivery_time']).to eq(restaurant.average_delivery_time)
      expect(JSON.parse(response.body)['restaurant']['manager_id']).to eq(restaurant.manager_id)
    end
    it 'should give unprocessable entity error if incorrect values are passed' do
      put :update, params: { id: @restaurant.id, restaurant: { name: nil, address: nil, area: nil, city: nil, state: nil, rating: nil, average_delivery_time: nil, average_cost_per_two: nil, manager_id: nil } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
    it 'should give unauthorized error when request without authorization token' do
      restaurant = FactoryBot.build(:restaurant, manager: @user)
      request.headers['Authorization'] = nil
      put :update, params: { id: @restaurant.id, restaurant: { name: restaurant.name, address: restaurant.address, area: restaurant.area, city: restaurant.city, state: restaurant.state, rating: restaurant.rating, average_delivery_time: restaurant.average_delivery_time, average_cost_per_two: restaurant.average_cost_per_two, manager_id: restaurant.manager_id } }
    end
    it 'should give unauthorized error when request with invalid authorization token' do
      restaurant = FactoryBot.build(:restaurant, manager: @user)
      request.headers['Authorization'] = Faker::Number.number(digits: 8)
      put :update, params: { id: @restaurant.id, restaurant: { name: restaurant.name, address: restaurant.address, area: restaurant.area, city: restaurant.city, state: restaurant.state, rating: restaurant.rating, average_delivery_time: restaurant.average_delivery_time, average_cost_per_two: restaurant.average_cost_per_two, manager_id: restaurant.manager_id } }
    end
    it 'should give unauthorized error when request with expired authorization token' do
      Timecop.travel(Faker::Date.between(from: 1.day.from_now, to: 1.year.from_now)) do
        restaurant = FactoryBot.build(:restaurant, manager: @user)
        put :update, params: { id: @restaurant.id, restaurant: { name: restaurant.name, address: restaurant.address, area: restaurant.area, city: restaurant.city, state: restaurant.state, rating: restaurant.rating, average_delivery_time: restaurant.average_delivery_time, average_cost_per_two: restaurant.average_cost_per_two, manager_id: restaurant.manager_id } }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
