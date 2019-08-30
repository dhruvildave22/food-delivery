# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuthTokenForm do
  before(:each) do
    @user = FactoryBot.create(:user)
    @auth_token_attrubutes = %w[user_id token expire_at]
    @auth_token = AuthTokenForm.new(FactoryBot.build(:auth_token, user_id: @user.id).attributes)
  end
  context 'validations' do
    it 'should be valid with valid parametes' do
      expect(@auth_token).to be_valid
    end
    it 'should be not be valid without attributes' do
      @auth_token_attrubutes.each do |attribute|
        expect(AuthTokenForm.new(FactoryBot.build(:auth_token, user_id: @user.id, attribute => nil).attributes)).to be_invalid
      end
    end
  end

  context 'persist' do
    it 'should save user if values are correct' do
      expect(@auth_token.persist).to eq true
    end
    it 'should raise error if value of auth_token is invalid' do
      @auth_token_attrubutes.each do |attribute|
        auth_token = AuthTokenForm.new(FactoryBot.build(:auth_token, user_id: @user.id, attribute => nil).attributes)
        expect { auth_token.persist }.to raise_error "#{attribute.humanize} can't be blank"
      end
    end
  end
end
