# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
    @user = FactoryBot.create(:user)
  end

  context 'associations' do
    it 'should has many auth tokens' do
      expect(@user).to have_many(:auth_tokens)
    end
    it 'should has one restaurant if role is restaurant manager' do
      user = FactoryBot.build(:user, role: 'manager')
      expect(user).to have_one(:restaurant)
    end
  end
  context 'generate reset password token' do
    it 'should generate a reset password token for user' do
      @user.generate_reset_password_token
      expect(@user.reset_password_token).not_to eq nil
    end
  end

  context 'reset password token expired?' do
    it 'should return true if reset password token has expired' do
      @user.generate_reset_password_token
      Timecop.travel(Faker::Date.between(from: 2.days.from_now, to: 1.year.from_now)) do
        expect(@user.reset_password_token_expired?).to eq true
      end
    end
    it 'should return false if reset password token has not expired' do
      @user.generate_reset_password_token
      expect(@user.reset_password_token_expired?).to eq false
    end
  end

  context 'clear auth tokens' do
    it 'should delete all auth tokens for user' do
      FactoryBot.create(:auth_token, user_id: @user.id)
      expect(@user.auth_tokens).not_to be_empty
      @user.clear_auth_tokens
      expect(@user.auth_tokens).to be_empty
    end
  end

  context 'clear_reset_password_token' do
    it 'should remove the reset password token of user' do
      @user.generate_reset_password_token
      expect(@user.reset_password_token).not_to eq nil
      @user.clear_reset_password_token
      expect(@user.reset_password_token).to eq nil
    end
  end

  context 'after update' do
    it 'should send an email on reset password token generation' do
      user = FactoryBot.create(:user)
      expect { user.generate_reset_password_token }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    it 'should not send an email on reset password token generation on invalid email' do
      user = FactoryBot.build(:user, email: nil)
      expect { user.generate_reset_password_token }.to change { ActionMailer::Base.deliveries.count }.by(0)
    end
  end
end
