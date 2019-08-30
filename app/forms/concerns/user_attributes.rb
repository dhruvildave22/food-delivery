# frozen_string_literal: true

module UserAttributes
  extend ActiveSupport::Concern
  ROLES = %w[admin manager customer delivery_agent customer_support].freeze
  DETAILED_INFO_ROLES = %w[customer delivery_agent].freeze
end
