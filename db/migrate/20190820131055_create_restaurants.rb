# frozen_string_literal: true

class CreateRestaurants < ActiveRecord::Migration[5.2]
  def change
    create_table :restaurants do |t|
      t.string :name
      t.string :address
      t.string :area
      t.string :city
      t.string :state
      t.decimal :rating
      t.integer :average_delivery_time
      t.float :average_cost_per_two
      t.integer :manager_id

      t.timestamps
    end
  end
end
