# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RestaurantForm do
  before(:all) do
    @restaurant_attributes = %w[name address area city state average_delivery_time average_cost_per_two rating manager_id]
    @user = FactoryBot.create(:user)
    @restaurant = RestaurantForm.new(FactoryBot.build(:restaurant, manager_id: @user.id).attributes)
  end
  context 'validations' do
    it 'should be valid with valid parametes' do
      expect(@restaurant).to be_valid
    end
    it 'should be not be valid without a manager' do
      @restaurant_attributes.each do |attribute|
        expect(RestaurantForm.new(FactoryBot.build(:restaurant, attribute => nil).attributes)).to be_invalid
      end
    end
  end

  context 'persist' do
    it 'should save restaurant if values are correct' do
      expect(@restaurant.persist).to eq true
    end
    it 'should raise error if value of restaurant is invalid' do
      @restaurant_attributes.each do |attribute|
        restaurant = RestaurantForm.new(FactoryBot.build(:restaurant, attribute => nil).attributes)
        expect { restaurant.persist }.to raise_error "#{attribute.humanize} can't be blank"
      end
    end
  end
end
