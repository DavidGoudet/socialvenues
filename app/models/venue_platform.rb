# frozen_string_literal: true

class VenuePlatform < ApplicationRecord
  enum platform_name: [:platform_a, :platform_b, :platform_c]
end
