# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  context 'associations' do
    it 'should belongs to a restaurant manager' do
      user = FactoryBot.create(:user, role: 'manager')
      restaurant = FactoryBot.create(:restaurant, manager_id: user.id)
      expect(restaurant).to belong_to(:manager)
    end
  end
end
