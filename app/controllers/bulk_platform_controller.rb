class BulkPlatformController < ApplicationController
  before_action :fetch_all
  protect_from_forgery with: :null_session

  def index
    @bulk_platform = Fetchers::FetchBulkPlatform.new.call
    render json: @bulk_platform.to_json(except: [:platform_name, :updated_at, :created_at])
  end

  def update
    Updaters::BulkUpdate.new(params).call
    render json: "Venues Updated", status: 200
  end

  private

  def fetch_all
    Fetchers::FetchPlatforms.new.call
  end
end
