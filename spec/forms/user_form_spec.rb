# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserForm do
  before(:all) do
    @user_attributes = %w[email role]
    @customer_attributes = %w[name phone_number city address state]
  end

  context 'validations' do
    it 'should be created with valid parametes' do
      user = FactoryBot.build(:user).attributes
      user.delete('password_digest')
      expect(UserForm.new(user.merge('password' => Faker::Alphanumeric.alpha(number: 8)))).to be_valid
    end
    it 'should not be created without a email, password and role' do
      @user_attributes.each do |attribute|
        expect(UserForm.new(FactoryBot.build(:user, attribute => nil).attributes)).to be_invalid
      end
    end

    it 'should not be created without customer info if role is customer' do
      @customer_attributes.each do |attribute|
        expect(UserForm.new(FactoryBot.build(:user, attribute => nil, role: 'customer').attributes)).to be_invalid
      end
    end

    it 'should be created without customer info if role is admin' do
      @customer_attributes.each do |attribute|
        expect(UserForm.new(FactoryBot.build(:user, role: 'admin', attribute => nil).attributes)).to be_valid
      end
    end

    it 'should not be created without customer info if role is delivery agent' do
      @customer_attributes.each do |attribute|
        expect(UserForm.new(FactoryBot.build(:user, role: 'delivery_agent', attribute => nil).attributes)).to be_invalid
      end
    end

    it 'should be created without customer info if role is restaurant manager' do
      @customer_attributes.each do |attribute|
        expect(UserForm.new(FactoryBot.build(:user, role: 'manager', attribute => nil).attributes)).to be_valid
      end
    end

    it 'should be created without customer info if role is customer support' do
      @customer_attributes.each do |attribute|
        expect(UserForm.new(FactoryBot.build(:user, role: 'customer_support', attribute => nil).attributes)).to be_valid
      end
    end

    it 'should not be created with a duplicate email' do
      user = FactoryBot.create(:user)
      expect(UserForm.new(FactoryBot.build(:user, email: user.email).attributes)).to be_invalid
    end
  end

  context 'persist' do
    it 'should save user if values are correct' do
      user = FactoryBot.build(:user).attributes
      user.delete('password_digest')
      user_form = UserForm.new(user.merge('password' => Faker::Alphanumeric.alpha(number: 8)))
      expect(user_form.persist).to eq true
    end
    it 'should raise error if value of user is invalid' do
      @user_attributes.each do |attribute|
        user = UserForm.new(FactoryBot.build(:user, attribute => nil).attributes)
        expect { user.persist }.to raise_error "#{attribute.humanize} can't be blank"
      end
    end
  end
end
