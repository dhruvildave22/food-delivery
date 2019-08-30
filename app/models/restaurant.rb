# frozen_string_literal: true

class Restaurant < ApplicationRecord
  belongs_to :manager, class_name: 'User'
end
