# frozen_string_literal: true

class Fetchers::PlatformCFetcher < ApplicationController
  def initialize
    @venue_platform = VenuePlatform.find_or_create_by(platform_name: :PlatformC)
    @url = ENV['base_url_platform_c'] + ENV['api_key']
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
      address_1:    platform_hash['address_line_1'],
      address_2:    platform_hash['address_line_2'],
      lat:          platform_hash['lat'],
      lng:          platform_hash['lng'],
      closed:       platform_hash['closed'],
      hours:        platform_hash['hours'],
      website:      platform_hash['website'],
      phone_number: platform_hash['phone_number'],
    )
  end

  def validate_information(platform_hash)
    matcher = MatchHourFormat.new(platform_hash['hours']).call
    hours_right_format = (matcher == :matches_platform_c)
    hours_right_format
  end
end
