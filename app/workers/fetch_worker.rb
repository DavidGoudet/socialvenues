# frozen_string_literal: true

class FetchWorker
  include Sidekiq::Worker

  def perform(platform_fetcher_class)
    platform_fetcher_class.constantize.new.call
  end
end
