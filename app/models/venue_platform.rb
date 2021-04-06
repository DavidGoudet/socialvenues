# frozen_string_literal: true

class VenuePlatform < ApplicationRecord
  enum platform_name: [:PlatformA, :PlatformB, :PlatformC]
end
