class BulkPlatformController < ApplicationController
  before_action :fetch_all
  protect_from_forgery with: :null_session

  def index
    @bulk_platform = Fetchers::FetchBulkPlatform.new.call
    render json: @bulk_platform.to_json(except: [:platform_name])
  end

  def update
    Updaters::BulkUpdate.new(params).call
  end

  private

  def fetch_all
    Fetchers::FetchPlatforms.new.call
  end
end
