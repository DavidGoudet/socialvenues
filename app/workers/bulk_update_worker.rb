class BulkUpdateWorker
  include Sidekiq::Worker

  def initialize(params)
    @params = params
  end

  def perform(platform_fetcherupdater_class)
    platform_updater_class.constantize.new(@params).call
  end
end
