# frozen_string_literal: true

class RestaurantForm
  include ActiveModel::Model

  attr_accessor :id, :name, :address, :area, :city, :state, :rating, :average_delivery_time, :average_cost_per_two, :manager_id, :created_at, :updated_at

  validates :name, :address, :area, :city, :state, :rating, :average_delivery_time, :average_cost_per_two, :manager_id, presence: true
  validates :rating, inclusion: { in: 0..5 }
  validates :rating, :average_cost_per_two, numericality: true

  def initialize(option = {}, id = nil)
    @restaurant = id.nil? ? Restaurant.new : Restaurant.find(id)
    @restaurant.attributes = option
    super(@restaurant.attributes)
  end

  def persist
    raise errors.full_messages.first unless valid?

    @restaurant.save!
  end
end
