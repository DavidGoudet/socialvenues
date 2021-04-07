# frozen_string_literal: true

class Fetchers::PlatformAFetcher < ApplicationController
  def initialize
    @venue_platform = VenuePlatform.find_or_create_by(platform_name: :PlatformA)
    @url = ENV['base_url_platform_a'] + ENV['api_key']
  end

  def call
    response = RestClient.get(@url)
    platform_hash = JSON.parse(response)
    if validate_information platform_hash
      save_information platform_hash 
    else
      return :error_saving
    end
  end

  def save_information(platform_hash)
    @venue_platform.update!(
      name:         platform_hash['name'],
      address_1:    platform_hash['address'],
      lat:          platform_hash['lat'],
      lng:          platform_hash['lng'],
      category_id:  platform_hash['category_id'],
      closed:       platform_hash['closed'],
      hours:        platform_hash['hours']
    )
  end

  def validate_information(platform_hash)
    cat_id = platform_hash['category_id']
    cat_id_inside_bounds = 1000 < cat_id && cat_id < 1200
    matcher = MatchHourFormat.new(platform_hash['hours']).call
    hours_right_format = (matcher == :matches_platform_a)
    cat_id_inside_bounds && hours_right_format
  end
end
