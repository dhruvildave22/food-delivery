# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuthToken, type: :model do
  before(:all) do
    @user = FactoryBot.create(:user)
  end
  context 'associations' do
    it 'should belongs to a user' do
      auth_token = FactoryBot.create(:auth_token, user_id: @user.id)
      expect(auth_token).to belong_to(:user)
    end
  end

  context 'callbacks' do
    it 'should set default value of token on initializing' do
      auth_token = FactoryBot.build(:auth_token, user_id: @user.id)
      auth_token.token = SecureRandom.urlsafe_base64(8)
      auth_token.save
      expect(auth_token).to be(auth_token)
    end
  end

  context 'expired' do
    it 'should return true if auth token has expired' do
      auth_token = FactoryBot.create(:auth_token, user_id: @user.id)
      Timecop.travel(Faker::Date.between(from: 2.day.from_now, to: 1.year.from_now)) do
        expect(auth_token.expired?).to eq true
      end
    end
    it 'should return false if auth token has not expired' do
      auth_token = FactoryBot.build(:auth_token, user_id: @user.id, created_at: Time.now)
      expect(auth_token.expired?).to eq false
    end
  end

  context 'create!' do
    it 'should create a auth_token if values are correct' do
      user = FactoryBot.create(:user)
      auth_token = FactoryBot.build(:auth_token, user_id: user.id)
      expect(auth_token.save).to eq true
    end
    it 'should raise error if values are incorrect' do
      auth_token = FactoryBot.build(:auth_token, user_id: Faker::Number.number(digits: 10))
      expect(auth_token.save).to eq false
    end
  end
end
