# frozen_string_literal: true

class VenuePlatformsController < ApplicationController
  def index    
    FetchPlatforms.new.call
    @venue_platforms = VenuePlatform.all
    render json: @venue_platforms
  end

  def show
  end

  def update
  end
end
