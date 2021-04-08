# frozen_string_literal: true

class Fetchers::PlatformBFetcher < ApplicationController
  def initialize
    @venue_platform = VenuePlatform.find_or_create_by(platform_name: :PlatformB)
    @url = ENV['base_url_platform_b'] + ENV['api_key']
  end

  def call
    response = RestClient.get(@url)
    if ResponseIsValidJson.new(response).call
      platform_hash = JSON.parse(response)
    else
      return :error_saving
    end

    if validate_information platform_hash
      save_information platform_hash 
    else
      return :error_saving
    end
  end

  private

  def save_information(platform_hash)
    @venue_platform.update!(
      name:         platform_hash['name'],
      address_1:    platform_hash['street_address'],
      lat:          platform_hash['lat'],
      lng:          platform_hash['lng'],
      category_id:  platform_hash['category_id'],
      closed:       platform_hash['closed'],
      hours:        platform_hash['hours']
    )
  end

  def validate_information(platform_hash)
    cat_id = platform_hash['category_id']
    cat_id_inside_bounds = 2000 < cat_id && cat_id < 2200
    matcher = MatchHourFormat.new(platform_hash['hours']).call
    hours_right_format = (matcher == :matches_platform_b)
    cat_id_inside_bounds && hours_right_format
  end
end
