# frozen_string_literal: true

class VenuePlatformsController < ApplicationController
  before_action :fetch_all, except: [:update]
  protect_from_forgery with: :null_session

  def index    
    @venue_platforms = VenuePlatform.all
    render json: @venue_platforms
  end

  def show
    render json: VenuePlatform.find(params[:id])
  end

  def update
    @venue_platform = VenuePlatform.find(params[:id])
    response = "Updaters::#{@venue_platform.platform_name}Updater".constantize.new(permitted_params(params)).call
    render json: response[:body], status: response[:code]
  end

  private

  def fetch_all
    fetcher = Fetchers::FetchPlatforms.new.call
    render json: "Error saving. The information we fetched is not valid.", status: 400 if fetcher == :error_saving
  end

  def permitted_params(params)
    params.permit(
      :name,
      :address,
      :address_1,
      :address_2,
      :lat,
      :lng,
      :category_id,
      :closed,
      :hours,
      :website,
      :phone_number,
      :street_address,
      :address_line_1,
      :address_line_2
    )
  end
end
