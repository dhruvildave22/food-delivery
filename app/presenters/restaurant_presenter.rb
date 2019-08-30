# frozen_string_literal: true

class RestaurantPresenter
  attr_reader :restaurant

  def initialize(restaurant)
    @restaurant = restaurant
  end

  def _show
    {
      id: restaurant.id,
      name: restaurant.name,
      address: restaurant.address,
      area: restaurant.area,
      city: restaurant.city,
      state: restaurant.state,
      rating: restaurant.rating,
      average_delivery_time: restaurant.average_delivery_time,
      average_cost_per_two: restaurant.average_cost_per_two,
      manager_id: restaurant.manager_id
    }
  end
end
