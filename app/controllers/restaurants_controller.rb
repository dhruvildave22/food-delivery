# frozen_string_literal: true

class RestaurantsController < ApplicationController
  before_action :exists, only: %i[show update destroy]

  def index
    restaurants = Restaurant.all
    render json: { restaurants: restaurants.map { |restaurant| RestaurantPresenter.new(restaurant)._show } }, status: :ok
  end

  def show
    render json: { restaurant: RestaurantPresenter.new(@restaurant)._show }, status: :ok
  end

  def create
    restaurant = RestaurantForm.new(restaurant_params)
    restaurant.persist
    render json: { restaurant: RestaurantPresenter.new(restaurant)._show }, status: :ok
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def update
    restaurant = RestaurantForm.new(restaurant_params, params[:id])
    restaurant.persist
    render json: { restaurant: RestaurantPresenter.new(restaurant)._show }, status: :ok
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def exists
    @restaurant = Restaurant.find_by(id: params[:id])
    render json: { error: 'restaurant is not available' }, status: :not_found unless @restaurant.present?
  end

  def restaurant_params
    params.require(:restaurant).permit(:name, :address, :area, :city, :state, :rating, :average_delivery_time, :average_cost_per_two, :manager_id)
  end
end
