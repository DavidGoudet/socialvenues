# frozen_string_literal: true

class Fetchers::FetchPlatforms < ApplicationController
  def initialize
    @fetch_worker = FetchWorker.new
  end

  def call
    VenuePlatform.platform_names.keys.each do |venue_platform|
      fetcher = @fetch_worker.perform("Fetchers::#{venue_platform}Fetcher")
      return :error_saving if fetcher == :error_saving
    end
  end
end
