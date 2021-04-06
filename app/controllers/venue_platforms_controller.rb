# frozen_string_literal: true

class VenuePlatformsController < ApplicationController
  before_action :fetch_all
  protect_from_forgery with: :null_session

  def index    
    @venue_platforms = VenuePlatform.all
    render json: @venue_platforms
  end

  def show
  end

  def update
    @venue_platform = VenuePlatform.find(params[:id])
    "Updaters::#{@venue_platform.platform_name}Updater".constantize.new(params).call
  end

  private

  def fetch_all
    Fetchers::FetchPlatforms.new.call
  end
end
