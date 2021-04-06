# frozen_string_literal: true

class Fetchers::FetchPlatforms < ApplicationController
  def initialize
    @fetch_worker = FetchWorker.new
  end

  def call
    VenuePlatform.find_each do |venue_platform|
      @fetch_worker.perform("Fetchers::#{venue_platform.platform_name}Fetcher")
    end
  end
end
