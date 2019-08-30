# frozen_string_literal: true

class CreateAuthTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :auth_tokens do |t|
      t.integer :user_id
      t.string :token
      t.datetime :expire_at

      t.timestamps
    end
  end
end
