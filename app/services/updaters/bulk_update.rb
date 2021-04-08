# frozen_string_literal: true

class Updaters::BulkUpdate < ApplicationController
  def initialize(params)
    @update_worker = BulkUpdateWorker.new(params)
  end

  def call
    VenuePlatform.platform_names.keys.each do |venue_platform|
      @update_worker.perform("Updaters::#{venue_platform}Updater")
    end
  end
end


