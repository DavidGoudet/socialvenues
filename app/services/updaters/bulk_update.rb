# frozen_string_literal: true

class Updaters::BulkUpdate < ApplicationController
  def initialize(params)
    @update_worker = UpdateWorker.new(params)
  end

  def call
    VenuePlatform.find_each do |venue_platform|
      @update_worker.perform("Updaters::#{venue_platform.platform_name}Updater")
    end
  end
end


