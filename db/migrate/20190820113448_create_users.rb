# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email
      t.string :role
      t.string :name
      t.string :phone_number
      t.string :address
      t.string :city
      t.string :state
      t.string :password_digest
      t.string :reset_password_token
      t.datetime :reset_password_token_expire_at

      t.timestamps
    end
  end
end
